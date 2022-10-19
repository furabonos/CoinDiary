//
//  EditViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation
import Combine
import UIKit

public enum ViewMode {
    case Edit
    case View
    case None
}

protocol EditViewModelInput {
    func clickAdd()
    func clickCancel()
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?)
}

protocol EditViewModelOutput {
    var viewMode: ViewMode { get }
    var viewModePublisher: PassthroughSubject<ViewMode, Never> { get }
    var saveData: Bool { get }
    var saveDataPublisher: PassthroughSubject<Bool, Never> { get }
}

public final class EditViewModel: EditViewModelInput, EditViewModelOutput, ObservableObject {
    
    var viewModePublisher = PassthroughSubject<ViewMode, Never>()
    public var viewMode = ViewMode.None {
        didSet {
            viewModePublisher.send(viewMode)
        }
    }
    
    var saveDataPublisher = PassthroughSubject<Bool, Never>()
    public var saveData = false {
        didSet {
            saveDataPublisher.send(saveData)
        }
    }
    
    private let useCase: EditUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var diary: DiaryEntity
    
    init(useCase: EditUseCaseInterface, diary: DiaryEntity) {
        self.useCase = useCase
        self.diary = diary
    }
    
    func clickAdd() {
        if self.viewMode == .None {
            self.viewMode = .None
        }else if viewMode == .View {
            self.viewMode = .None
        }else {
            //Edit 여기는 데이터보내는곳임
        }
    }
    
    func clickCancel() {
        if self.viewMode == .None {
            self.viewMode = .Edit
        }else if viewMode == .View {
            self.viewMode = .Edit
        }else {
            //Edit
            self.viewMode = .View
        }
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
