//
//  SpeechThreshold.swift
//  LiveSTT
//
//  Created by William on 2026/8/19.
//

import Foundation
import WWMicrophoneInput

/// 語音偵測閾值設定
final class SpeechThreshold {
    
    private let amplitude: Float    // 振幅閾值（低於此值認為是沉默）
    private let silence: Int        // 沉默緩衝數量（連續幾個 buffer 沒聲音才認為說話結束）
    
    private var isSpeaking = false  // 目前是否在說話狀態
    private var muteCount = 0       // 沉默計數器
    
    /// 建立 SpeechThreshold 實體
    /// - Parameters:
    ///   - amplitude: 振幅閾值（低於此值認為是沉默）
    ///   - silence: 沉默緩衝數量（連續幾個 buffer 沒聲音才認為說話結束）
    init(amplitude: Float = 0.01, silence: Int = 10) {
        self.amplitude = amplitude
        self.silence = silence
    }
    
    /// 偵測 buffer 是否包含語音
    ///
    /// - Parameter buffer: 音訊緩衝區
    /// - Returns: 是否應該處理此 buffer（true = 有語音，false = 沉默）
    func detect(from buffer: WWAudioPCMBuffer) -> Bool {
        
        guard let amplitude = buffer.amplitude else { return false }
        
        let isSpeech = amplitude > self.amplitude
        
        if isSpeech {
            isSpeaking = true
            muteCount = 0
            return true
        }
        
        if !isSpeaking { return false }
        
        muteCount += 1
        
        if muteCount >= silence {
            isSpeaking = false
            muteCount = 0
            return false
        }
        
        return true
    }
    
    /// 重置狀態
    func reset() {
        isSpeaking = false
        muteCount = 0
    }
}
