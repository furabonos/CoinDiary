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
        let digit: Double = pow(10, 1)
        let first = ((end / start) - 1) * 100
        return "\(round(first * digit) / digit)%"
    }
}
