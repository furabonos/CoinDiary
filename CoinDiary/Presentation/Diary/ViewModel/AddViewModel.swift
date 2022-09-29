//
//  AddViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import Combine
import UIKit

protocol AddViewModelInput {
//    var userProfile: UserEntity? { get }
//    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    var viewDismissalModePublisher: PassthroughSubject<Bool, Never> { get }
    var saveDataPublisher: PassthroughSubject<Bool, Never> { get }
    var shouldPopView: Bool { get }
    var saveData: Bool { get }
}

protocol AddViewModelOutput {
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?)
    func clickCancel()
}

public final class AddViewModel: AddViewModelInput, AddViewModelOutput, ObservableObject {
    
    public var shouldPopView = false {
        didSet {
            viewDismissalModePublisher.send(shouldPopView)
        }
    }
    
    public var saveData = false {
        didSet {
            saveDataPublisher.send(saveData)
        }
    }

    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    var saveDataPublisher = PassthroughSubject<Bool, Never>()
    
    private let useCase: AddUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
//    private let action: DiaryViewModelAction?
//    let menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"]
    
    
    init(useCase: AddUseCaseInterface) {
        self.useCase = useCase
    }
    
    func clickCancel() {
        self.shouldPopView = true
    }
    
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?) {
        useCase.saveData(date: date, start: start, end: end, memo: memo, image: image) { result in
            switch result {
            case true:
                self.saveData = true
            case false:
                self.saveData = false
            }
        }
    }
    
}
