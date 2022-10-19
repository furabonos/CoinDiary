//
//  CoinUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/18.
//

import Foundation
import Combine
import Alamofire

public protocol CoinUseCaseInterface {
    func getTicker(completion: @escaping (AnyPublisher<CoinEntity, AFError>) -> Void)
}

public final class CoinUseCase: CoinUseCaseInterface {
    
    private let repository: CoinRepositoryInterface
    
    public init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    public func getTicker(completion: @escaping (AnyPublisher<CoinEntity, AFError>) -> Void) {
        repository.getTicker { result in
            completion(result)
        }
    }
}
