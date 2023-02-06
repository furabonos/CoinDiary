//
//  StringExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/04.
//

import UIKit
import CryptoKit
import Foundation

extension String {
    var toDouble: Double {
        var doubles = self.replacingOccurrences(of: "USDT", with: "").replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: "")
        return Double(doubles)!
    }
    
    var cutYear: String {
        return String(self.suffix(4))
    }
//    var aaaa = getStringUserDefaults(key: "UUID")
//    let data = aaaa.data(using: .utf8)
//    let sha = SHA256.hash(data: data!)
//    let stringHash = sha.compactMap { String(format: "%02x", $0)}.joined()
    var sha256: String {
        let data = self.data(using: .utf8)
        let sha = SHA256.hash(data: data!)
        return sha.compactMap { String(format: "%02x", $0)}.joined()
    }
}

