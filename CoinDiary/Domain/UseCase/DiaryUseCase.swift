//
//  DiaryUseCase.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

public protocol DiaryUseCaseInterface {
    func fetchData(completion: @escaping (AnyPublisher<[DiaryEntity], Error>) -> Void)
    func addSnapshot(completion: @escaping (AnyPublisher<DiaryEntity, Error>) -> Void)
    func removeAllData(completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class DiaryUseCase: DiaryUseCaseInterface {
    
    private let repository: DiaryRepositoryInterface
    
    public init(repository: DiaryRepositoryInterface) {
        self.repository = repository
    }
    
    public func fetchData(completion: @escaping (AnyPublisher<[DiaryEntity], Error>) -> Void) {
        repository.fetchData { result in
            completion(result)
        }
    }
    
    public func removeAllData(completion: @escaping (Bool) -> Void) -> Cancellable? {
        repository.removeAllData { result in
            completion(result)
        }
    }
    
    public func addSnapshot(completion: @escaping (AnyPublisher<DiaryEntity, Error>) -> Void) {
        repository.addSnapshot { result in
            completion(result)
        }
    }
}

