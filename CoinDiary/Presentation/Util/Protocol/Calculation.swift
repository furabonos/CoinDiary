//
//  Calculation.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import Foundation
import UIKit

public protocol Calculation {}
public extension Calculation {
    
    func yieldCalculation(start: Double, end: Double) -> String {
//        var a = Double(500)
//        var b = Double(400)
//        let digit: Double = pow(10, 1)
//        var rere = ((b / a) - 1) * 100
//        var rerere = round(rere * digit) / digit
        let digit: Double = pow(10, 1)
        let first = ((end / start) - 1) * 100
        return "\(round(first * digit) / digit)%"
    }
}
