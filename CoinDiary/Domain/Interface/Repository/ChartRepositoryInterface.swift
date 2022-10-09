//
//  ChartRepositoryInterface.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/18.
//

import Foundation
import Combine

public protocol ChartRepositoryInterface {
    func fetchData(completion: @escaping (AnyPublisher<[[String]], Error>) -> Void)
}
