//
//  DiaryViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine

struct DiaryViewModelAction {
    let showAddViewController: () -> Void
}

protocol DiaryViewModelInput {
    
}

protocol DiaryViewModelOutput {
    var menuList: Array<String> { get }
}

public final class DiaryViewModel: DiaryViewModelInput, DiaryViewModelOutput, ObservableObject {
    
    private let useCase: DiaryUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private let action: DiaryViewModelAction?
    let menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"]
    
    
    init(useCase: DiaryUseCaseInterface, actions: DiaryViewModelAction? = nil) {
        self.useCase = useCase
        self.action = actions
    }
    
    public func showAddViewController() {
        action?.showAddViewController()
    }
    
}
