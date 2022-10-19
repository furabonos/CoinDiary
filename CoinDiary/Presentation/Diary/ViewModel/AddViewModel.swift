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
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?)
    func clickCancel()
}

protocol AddViewModelOutput {
    var viewDismissalModePublisher: PassthroughSubject<Bool, Never> { get }
    var saveDataPublisher: PassthroughSubject<Bool, Never> { get }
    var shouldPopView: Bool { get }
    var saveData: Bool { get }
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
