//
//  CoinDataSource.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/14.
//

import Foundation
import Combine
import Alamofire

public protocol CoinDataSourceInterface {
    func getTicker(completion: @escaping (AnyPublisher<CoinDTO, AFError>) -> Void)
    
}

public final class CoinDataSource: CoinDataSourceInterface {
    
    public func getTicker(completion: @escaping (AnyPublisher<CoinDTO, AFError>) -> Void) {
        
        let urls = "https://fapi.binance.com/fapi/v1/exchangeInfo"
        
        completion(
            AF.request(urls, method: .get, encoding: URLEncoding.default)
                .validate()
                .publishDecodable(type: CoinDTO.self)
                .value()
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        )
    }
    
}
