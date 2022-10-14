//
//  DateExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import UIKit

extension Date {
    var getToday: String {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYMMdd"
        var today = formatter.string(from: Date())
        return today
    }
}
