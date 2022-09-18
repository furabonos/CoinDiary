//
//  ChartUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/18.
//

import Foundation
import Combine

public protocol ChartUseCaseInterface {
    
}

public final class ChartUseCase: ChartUseCaseInterface {
    
    private let repository: ChartRepositoryInterface
    
    public init(repository: ChartRepositoryInterface) {
        self.repository = repository
    }
}
