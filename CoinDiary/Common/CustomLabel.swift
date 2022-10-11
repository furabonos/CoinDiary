//
//  CustomLabel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/22.
//

import Foundation
import UIKit

class LeftPaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
        @IBInspectable var bottomInset: CGFloat = 0.0
        @IBInspectable var leftInset: CGFloat = 20.0
        @IBInspectable var rightInset: CGFloat = 0.0
     
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
        }
        override var bounds: CGRect {
            didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
        }
}

class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
        @IBInspectable var bottomInset: CGFloat = 0.0
        @IBInspectable var leftInset: CGFloat = 10.0
        @IBInspectable var rightInset: CGFloat = 10.0
     
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
        }
        override var bounds: CGRect {
            didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
        }
}
