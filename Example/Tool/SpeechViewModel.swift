//
//  SpeechViewModel.swift
//  LiveSTT
//
//  Created by William.Weng on 2026/8/18.
//

import SwiftUI
import Speech
import WWAudioStreamTranscription
import WWMicrophoneInput

/// 語音辨識的 ViewModel
@Observable
final class SpeechViewModel {
    
    var text = ""                                               // 目前辨識出的文字結果
    var isRecording = false                                     // 是否正在錄音中
    var errorMessage: String?                                   // 錯誤訊息（若有）
    var language: SupportedLanguage                             // 語音辨識使用的語言
    
    @ObservationIgnored
    private let threshold: SpeechThreshold = .init()            // 語音偵測閾值設定
    
    @ObservationIgnored
    private var microphoneInput: WWMicrophoneInput?             // 麥克風輸入管理器
    
    @ObservationIgnored
    private var transcription: WWAudioStreamTranscription?      // 音訊串流轉文字物件
        
    /// 初始化語言設定
    ///
    /// - Parameter language: 預設語言，預設為繁體中文（台灣）
    init(language: SupportedLanguage = .TW) {
        self.language = language
    }
}

// MARK: - Public Actions
extension SpeechViewModel {
    
    /// 切換錄音狀態：若正在錄音則停止，否則開始
    func toggle() {
        isRecording ? stop(): start()
    }
    
    /// 開始語音辨識
    ///
    /// 會先請求權限，再建立音訊管線，並更新錄音狀態
    func start() {
        
        guard !isRecording else { return }
        
        text = ""
        errorMessage = nil
        
        Task { @MainActor in
            do {
                try await requestPermissions()
                try createAudioPipeline()
                isRecording = true
            } catch {
                errorMessage = error.localizedDescription
                stop()
            }
        }
    }
    
    /// 停止語音辨識
    ///
    /// 會停止麥克風輸入、結束轉寫，並清理相關物件與狀態
    func stop() {

        try? microphoneInput?.stop()
        transcription?.finish()
        
        microphoneInput = nil
        transcription = nil
        
        isRecording = false
    }
    
    /// 取消錄音
    ///
    /// 與 stop() 類似，但使用 cancel() 表示不產出最終結果
    func cancel() {
        
        try? microphoneInput?.stop()
        transcription?.cancel()
        
        microphoneInput = nil
        transcription = nil
        
        isRecording = false
    }
}

// MARK: - Audio Pipeline
private extension SpeechViewModel {
    
    /// 建立音訊管線：初始化轉寫物件與麥克風輸入，並連接兩者
    ///
    /// - Throws: 若初始化或啟動失敗則拋出錯誤
    func createAudioPipeline() throws {
        
        let locale = Locale(identifier: language.identity)
        let transcription = try WWAudioStreamTranscription(locale: locale)
        let threshold = self.threshold
        
        transcription.onResult = { [weak self] text, isFinal in
            
            Task { @MainActor in
                self?.text = text
                if isFinal { self?.isRecording = false }
            }
        }
        
        transcription.onError = { [weak self] error in
            
            Task { @MainActor in
                self?.errorMessage = error.localizedDescription
                self?.stop()
            }
        }
        
        let microphone = WWMicrophoneInput { [weak transcription] buffer in
            if !threshold.detect(from: buffer) { return }
            transcription?.append(buffer: buffer.value)
        }
        
        try microphone.configure()
        try transcription.start()
        try microphone.start()
        
        self.transcription = transcription
        self.microphoneInput = microphone
    }
}

// MARK: - Permissions
private extension SpeechViewModel {
    
    /// 請求語音辨識與麥克風權限
    ///
    /// - Throws: 若任一權限被拒絕，則拋出對應的 SpeechError
    func requestPermissions() async throws {
        
        let speechStatus = await requestSpeechAuthorization()
        guard speechStatus == .authorized else { throw SpeechError.speechAuthorizationDenied }
        
        let microphoneGranted = await requestMicrophoneAuthorization()
        guard microphoneGranted else { throw SpeechError.microphoneAuthorizationDenied}
    }
    
    /// 請求語音辨識授權，並回傳授權狀態
    ///
    /// - Returns: SFSpeechRecognizer 的授權狀態
    func requestSpeechAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        await WWAudioStreamTranscription.requestAuthorization()
    }
    
    /// 請求麥克風錄音權限
    /// 
    /// - Returns: 若使用者允許錄音則回傳 true，否則 false
    func requestMicrophoneAuthorization() async -> Bool {
        await WWMicrophoneInput.requestAuthorization()
    }
}
