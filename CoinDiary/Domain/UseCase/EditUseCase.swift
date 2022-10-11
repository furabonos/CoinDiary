//
//  EditUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation

import Combine

public protocol EditUseCaseInterface {

}

public final class EditUseCase: EditUseCaseInterface {
    
    private let repository: EditRepositoryInterface
    
    public init(repository: EditRepositoryInterface) {
        self.repository = repository
    }
}
