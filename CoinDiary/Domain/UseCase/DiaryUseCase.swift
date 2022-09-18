//
//  DiaryUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

public protocol DiaryUseCaseInterface {
    
}

public final class DiaryUseCase: DiaryUseCaseInterface {
    
    private let repository: DiaryRepositoryInterface
    
    public init(repository: DiaryRepositoryInterface) {
        self.repository = repository
    }
}

