//
//  AddRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import Combine

public final class AddRepository: AddRepositoryInterface {
    
    private let dataSource: AddDataSourceInterface
    
    public init(dataSource: AddDataSourceInterface) {
        self.dataSource = dataSource
    }
    
}
