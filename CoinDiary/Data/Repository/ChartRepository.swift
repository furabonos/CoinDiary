//
//  ChartRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/18.
//

import Foundation
import Combine

public final class ChartRepository: ChartRepositoryInterface {
    
    private let dataSource: ChartDataSourceInterface
    
    public init(dataSource: ChartDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func fetchData(completion: @escaping (AnyPublisher<[[String]], Error>) -> Void) {
        dataSource.fetchData { result in
            completion(
                result
            )
        }
    }
    
}
