//
//  AddRepositoryInterface.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import UIKit

public protocol AddRepositoryInterface {
    func saveData(date: String, start: String, end: String, memo: String, type: String, image: UIImage?, register: String, completion: @escaping (Bool) -> Void) -> Cancellable?
}
