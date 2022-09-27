//
//  UserDefault.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/25.
//

import UIKit
import Foundation

public protocol UserDefault {}
public extension UserDefault {
    
    func saveStringUserDefaults(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getStringUserDefaults(key: String) -> String {
        guard let value = UserDefaults.standard.string(forKey: key) else { return "" }
        return value
    }
}
