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
    let showEditViewController: (DiaryEntity) -> Void
}

protocol DiaryViewModelInput {
    func fetchData()
    func addSnapshot()
    func fetchData2(completions: @escaping(String) -> Void)
}

protocol DiaryViewModelOutput {
    var menuList: Array<String> { get }
    var diaryList: [DiaryEntity] { get }
    var diary: DiaryEntity { get }
}

public final class DiaryViewModel: DiaryViewModelInput, DiaryViewModelOutput, ObservableObject {
    
    private let useCase: DiaryUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private let action: DiaryViewModelAction?
    let menuList = ["날짜", "시작금액", "종료금액", "수익률", "메모"]
    
    @Published public var diaryList: [DiaryEntity] = []
    @Published public var diary = DiaryEntity(imageURL: nil, memo: nil, start: "", end: "", today: "")
    
    init(useCase: DiaryUseCaseInterface, actions: DiaryViewModelAction? = nil) {
        self.useCase = useCase
        self.action = actions
    }
    
    func fetchData() {
        useCase.fetchData {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.diaryList = []
                }
            } receiveValue: { diaryList in
                self.diaryList = diaryList
            }
            .store(in: &bag)
        }
    }
    
    func fetchData2(completions: @escaping (String) -> Void) {
        useCase.fetchData {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.diaryList = []
                    completions("failure")
                }
            } receiveValue: { diaryList in
                self.diaryList = diaryList
                completions("success")
            }
            .store(in: &bag)
        }
    }
    
    func addSnapshot() {
        useCase.addSnapshot {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("errors = \(error)")
                }
            } receiveValue: { diaries in
                print("snapshotData = \(diaries)")
            }
            .store(in: &bag)
        }
    }
    
    public func showAddViewController() {
        action?.showAddViewController()
    }
    
    public func showEditViewController(diary: DiaryEntity) {
//        print("didididia = \(diary)")
        action?.showEditViewController(diary)
    }
    
}
