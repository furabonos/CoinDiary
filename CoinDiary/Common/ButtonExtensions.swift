//
//  ButtonExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/25.
//

import UIKit

extension UIButton {
    func addAllShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6
    }
}
