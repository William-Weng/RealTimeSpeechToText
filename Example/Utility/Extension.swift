//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2026/8/13.
//

import Foundation
import AVFAudio

// MARK: - AVAudioRecorder
extension String {
    
    /// 將二位字母國家代碼轉換為國旗 Emoji (ISO 3166-1)
    var flag: String {
        
        guard count == 2 else { return self }
        
        let base: UInt32 = 127397
        
        var result = ""
        for char in uppercased() {
            if let scalar = Unicode.Scalar(UInt32(char.asciiValue!) + base) {
                result.append(String(scalar))
            }
        }
        return result
    }
}
