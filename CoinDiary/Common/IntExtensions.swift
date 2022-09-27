//
//  IntExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/26.
//

import UIKit

extension Int {
    var withComma: String {
            let decimalFormatter = NumberFormatter()
            decimalFormatter.numberStyle = NumberFormatter.Style.decimal
            decimalFormatter.groupingSeparator = ","
            decimalFormatter.groupingSize = 3
             
            return decimalFormatter.string(from: self as NSNumber)!
        }
}
