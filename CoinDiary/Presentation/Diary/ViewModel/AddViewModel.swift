//
//  AddViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import Combine

protocol AddViewModelInput {
    
}

protocol AddViewModelOutput {
    
}

public final class AddViewModel: AddViewModelInput, AddViewModelOutput, ObservableObject {
    
    private let useCase: AddUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
//    private let action: DiaryViewModelAction?
//    let menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"]
    
    
    init(useCase: AddUseCaseInterface) {
        self.useCase = useCase
//        self.action = actions
    }
    
}
