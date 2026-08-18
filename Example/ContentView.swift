//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/7.
//
//  <key>NSMicrophoneUsageDescription</key>
//  <string>需要使用麥克風進行語音辨識</string>
//
//  <key>NSSpeechRecognitionUsageDescription</key>
//  <string>需要使用語音辨識將聲音轉換為文字</string>

import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    
    @State private var viewModel = SpeechViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {
                resultTextView
                if let errorMessage = viewModel.errorMessage {
                    errorMessageView(errorMessage)
                }
                startButton
            }
            .padding()
            .navigationTitle("語音辨識")
        }
    }
}

// MARK: - Private Subviews
private extension ContentView {
    
    /// 辨識結果的文字顯示區域
    ///
    /// 使用 ScrollView 包圍 Text，支援多行顯示與捲動
    var resultTextView: some View {
        
        ScrollView {
            Text(viewModel.text.isEmpty ? "請按下按鈕開始說話" : viewModel.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 240)
        .background(.blue.opacity(0.1))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
    
    /// 錯誤訊息的顯示視圖
    ///
    /// 以紅色小字顯示，並佔滿水平寬度
    /// - Parameter errorMessage: 要顯示的錯誤訊息文字。
    func errorMessageView(_ errorMessage: String) -> some View {
        
        Text(errorMessage)
            .font(.footnote)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
    }
    
    /// 開始/停止辨識的按鈕
    /// 
    /// 根據當前是否正在錄音，切換按鈕文字與圖示
    var startButton: some View {
        
        Button {
            viewModel.toggle()
        } label: {
            Label(
                viewModel.isRecording ? "停止辨識" : "開始辨識",
                systemImage: viewModel.isRecording ? "stop.circle.fill": "mic.circle.fill"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(viewModel.isRecording ? .red: .blue)
    }
}

#Preview {
    ContentView()
}
