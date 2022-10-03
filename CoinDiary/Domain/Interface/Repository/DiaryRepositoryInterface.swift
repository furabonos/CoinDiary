//
//  DiaryRepositoryInterface.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

public protocol DiaryRepositoryInterface {
    func fetchData(completion: @escaping (AnyPublisher<[DiaryEntity], Error>) -> Void)
    func addSnapshot(completion: @escaping (AnyPublisher<DiaryEntity, Error>) -> Void)
}
