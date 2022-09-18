//
//  ChartViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

protocol ChartViewModelInput {
    
}

protocol ChartViewModelOutput {
    
}

public final class ChartViewModel: ChartViewModelInput, ChartViewModelOutput, ObservableObject {
    
    private let useCase: ChartUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(useCase: ChartUseCaseInterface) {
        self.useCase = useCase
//        self.action = actions
    }
    
}
