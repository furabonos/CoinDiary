//
//  AddUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation

public protocol AddUseCaseInterface {
    
}

public final class AddUseCase: AddUseCaseInterface {
    
    private let repository: AddRepositoryInterface
    
    public init(repository: AddRepositoryInterface) {
        self.repository = repository
    }
}
