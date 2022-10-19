//
//  CoinRepositoryInterface.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/18.
//

import Foundation
import Combine
import Alamofire

public protocol CoinRepositoryInterface {
    func getTicker(completion: @escaping (AnyPublisher<CoinEntity, AFError>) -> Void)
}
