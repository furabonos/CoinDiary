//
//  AddUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation

public protocol AddUseCaseInterface {
    func saveData(date: String, start: String, end: String, memo: String, completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class AddUseCase: AddUseCaseInterface {
    
    private let repository: AddRepositoryInterface
    
    public init(repository: AddRepositoryInterface) {
        self.repository = repository
    }
    
    public func saveData(date: String, start: String, end: String, memo: String, completion: @escaping (Bool) -> Void) -> Cancellable? {
        repository.saveData(date: date, start: start, end: end, memo: memo) { result in
            completion(result)
        }
    }
}
