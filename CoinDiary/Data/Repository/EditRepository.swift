//
//  EditRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation
import Combine
import UIKit

public final class EditRepository: EditRepositoryInterface {
    
    private let dataSource: EditDataSourceInterface
    
    public init(dataSource: EditDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func saveData(date: String, start: String, end: String, memo: String, image: UIImage?, type: String, register: String, completion: @escaping (Bool) -> Void) -> Cancellable? {
        dataSource.saveData(date: date, start: start, end: end, memo: memo, image: image, type: type, register: register) { result in
            completion(result)
        }
    }
    
    public func removeData(date: String, completion: @escaping (Bool) -> Void) -> Cancellable? {
        dataSource.removeData(date: date) { result in
            completion(result)
        }
    }
    
}
