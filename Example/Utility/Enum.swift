//
//  Enum.swift
//  LiveSTT
//
//  Created by William.Weng on 2026/8/13.
//

import Foundation

// 語系支援
enum SupportedLanguage: String, CaseIterable {
    
    case US     // 英文（美國）
    case TW     // 繁體中文（台灣）
    case JP     // 日文（日本）
    case KR     // 韓國語（韓國）
}

// MARK: - 公開屬性
extension SupportedLanguage {
    
    /// 語言對應的國旗 Emoji
    var flag: String {
        rawValue.flag
    }
    
    /// Apple 語言識別碼
    var identity: String {
        switch self {
        case .US: "en-US"
        case .TW: "zh-TW"
        case .JP: "ja-JP"
        case .KR: "ko-KR"
        }
    }
    
    /// 顯示在畫面上的語言名稱
    var name: String {
        switch self {
        case .US: "English"
        case .TW: "繁體中文"
        case .JP: "日本語"
        case .KR: "한국어"
        }
    }
    
    /// 語言對應的提示語
    var message: String {
        switch self {
        case .US: "Press the button and start speaking!"
        case .TW: "請按下按鈕開始說話"
        case .JP: "ボタンを押して話し始めてください！"
        case .KR: "버튼을 누르고 말하기 시작하세요!"
        }
    }
    
    /// 開始使用的標題
    var startMessage: String {
        switch self {
        case .US: "Start Recognition"
        case .TW: "開始辨識"
        case .JP: "認識を開始"
        case .KR: "인식 시작"
        }
    }
    
    /// 停止使用的標題
    var stopMessage: String {
        switch self {
        case .US: "Stop Recognition"
        case .TW: "停止辨識"
        case .JP: "認識を停止"
        case .KR: "인식 중지"
        }
    }
        
    /// 語言對應的標題
    var title: String {
        switch self {
        case .US: "Speech Recognition"
        case .TW: "語音辨識"
        case .JP: "音声認識"
        case .KR: "음성 인식"
        }
    }
}
