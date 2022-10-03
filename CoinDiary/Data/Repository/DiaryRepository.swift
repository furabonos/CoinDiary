//
//  DiaryRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

public final class DiaryRepository: DiaryRepositoryInterface {
    
    private let dataSource: DiaryDataSourceInterface
    
    public init(dataSource: DiaryDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func fetchData(completion: @escaping (AnyPublisher<[DiaryEntity], Error>) -> Void) {
        dataSource.fetchData { result in
            completion(
                result.map({ diaryDTOList in
                    var diaryEntities = [DiaryEntity]()
                    for diary in diaryDTOList {
                        diaryEntities.append(diary.dto())
                    }
                    return diaryEntities
                })
                .eraseToAnyPublisher()
            )
        }
    }
    
    public func addSnapshot(completion: @escaping (AnyPublisher<DiaryEntity, Error>) -> Void) {
        dataSource.addSnapshot { result in
            completion(
                result.map({ diaryDTO in
                    var diaryEntity: DiaryEntity
                    diaryEntity = diaryDTO.dto()
                    return diaryEntity
                })
                .eraseToAnyPublisher()
            )
        }
    }
    
}
