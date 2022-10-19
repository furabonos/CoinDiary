//
//  CoinRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/18.
//

import Foundation
import Combine
import Alamofire

public final class CoinRepository: CoinRepositoryInterface {
    
    private let dataSource: CoinDataSourceInterface
    
    public init(dataSource: CoinDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func getTicker(completion: @escaping (AnyPublisher<CoinEntity, AFError>) -> Void) {
        dataSource.getTicker { result in
            completion(
                result.map({ coinDTOList in
                    var coinz = coinDTOList.symbols.map({ $0.toDomain() })
                    var coinEntity = CoinEntity(symbols: coinz)
                    return coinEntity
                })
                .eraseToAnyPublisher()
            )
        }
    }
    
}
