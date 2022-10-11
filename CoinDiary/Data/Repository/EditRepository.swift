//
//  EditRepository.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation
import Combine

public final class EditRepository: EditRepositoryInterface {
    
    private let dataSource: EditDataSourceInterface
    
    public init(dataSource: EditDataSourceInterface) {
        self.dataSource = dataSource
    }
    
}
