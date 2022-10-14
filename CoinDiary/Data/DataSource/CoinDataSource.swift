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
    func getTicker() -> AnyPublisher<CoinDTO, AFError>
}

public final class CoinDataSource: CoinDataSourceInterface {
    
    public func getTicker() -> AnyPublisher<CoinDTO, AFError> {
        
        let urls = "https://fapi.binance.com/fapi/v1/exchangeInfo"
        
        return AF.request(urls, method: .get, encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: CoinDTO.self)
            .value()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
