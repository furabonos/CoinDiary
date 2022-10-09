//
//  StringExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/04.
//

import UIKit

extension String {
    var toDouble: Double {
        var doubles = self.replacingOccurrences(of: "USDT", with: "").replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: "")
        return Double(doubles)!
    }
    
    var cutYear: String {
        return String(self.suffix(4))
    }
}
