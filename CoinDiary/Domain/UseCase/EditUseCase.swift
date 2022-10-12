//
//  EditUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation
import UIKit
import Combine

public protocol EditUseCaseInterface {
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?, completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class EditUseCase: EditUseCaseInterface {
    
    private let repository: EditRepositoryInterface
    
    public init(repository: EditRepositoryInterface) {
        self.repository = repository
    }
    
    public func saveData(date: String, start: String, end: String, memo: String, image: UIImage?, completion: @escaping (Bool) -> Void) -> Cancellable? {
        repository.saveData(date: date, start: start, end: end, memo: memo, image: image) { result in
            completion(result)
        }
    }
}
