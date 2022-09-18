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
    
}
