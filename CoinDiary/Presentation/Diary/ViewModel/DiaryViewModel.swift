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
    func fetchData()
    func addSnapshot()
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
        print("또타진않지?")
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
    
    func addSnapshot() {
        print("addsnsnsnsnsnsnsnsnsnsnsnsnsnsns")
        useCase.addSnapshot {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("errors = \(error)")
                }
            } receiveValue: { diaries in
                print("몇번타냐")
                if diaries != nil {
                    if self.diaryList.count != 0 {
                        if diaries != self.diaryList[0] {
                            self.diary = diaries
                            self.diaryList.remove(at: 0)
                            self.diaryList.insert(diaries, at: 0)
                        }
                    }
                }
                print("최종데이타? = \(self.diaryList)")
            }
            .store(in: &bag)
        }
    }
    
    public func showAddViewController() {
        action?.showAddViewController()
    }
    
}
