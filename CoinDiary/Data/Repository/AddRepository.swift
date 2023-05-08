//
//  AddRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import Combine
import UIKit

public final class AddRepository: AddRepositoryInterface {
    
    private let dataSource: AddDataSourceInterface
    
    public init(dataSource: AddDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func saveData(date: String, start: String, end: String, memo: String, type: String, image: UIImage?,  completion: @escaping (Bool) -> Void) -> Cancellable? {
        dataSource.saveData(date: date, start: start, end: end, memo: memo, type: type, image: image) { result in
            completion(result)
        }
    }
    
}
