//
//  EditRepositoryInterface.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation
import Combine
import UIKit

public protocol EditRepositoryInterface {
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?, type: String, register: String, completion: @escaping (Bool) -> Void) -> Cancellable?
    func removeData(date: String, completion: @escaping (Bool) -> Void) -> Cancellable?
}
