//
//  TextFieldExtensions.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/22.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
