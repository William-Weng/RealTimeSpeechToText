//
//  SpeechError.swift
//  Example
//
//  Created by William.Weng on 2026/8/18.
//

import Foundation

enum SpeechError: LocalizedError {
    
    case speechAuthorizationDenied
    case microphoneAuthorizationDenied
    
    var errorDescription: String? {
        switch self {
        case .speechAuthorizationDenied: "語音辨識權限未開啟。"
        case .microphoneAuthorizationDenied: "麥克風權限未開啟。"
        }
    }
}
