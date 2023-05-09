//
//  ChartViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine
import UIKit

protocol ChartViewModelInput {
    func fetchData()
}

protocol ChartViewModelOutput {
    var dateList: Array<String> { get }
    var endList: Array<Double> { get }
}

public final class ChartViewModel: ChartViewModelInput, ChartViewModelOutput, ObservableObject {
    
    private let useCase: ChartUseCaseInterface
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published public var dateList: [String] = []
    @Published public var endList: [Double] = []
    
    init(useCase: ChartUseCaseInterface) {
        self.useCase = useCase
    }
    
    func fetchData() {
        [dateList, endList].forEach { m in
            print(m)
        }
        useCase.fetchData {[unowned self] result in
            result.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error = \(error)")
                }
            } receiveValue: { diaryList in
                diaryList[0].map {
                    print($0.cutYear)
                    self.dateList.append($0.cutYear)
                }
                
                diaryList[1].map {
                    print($0.toDouble)
                    self.endList.append($0.toDouble)
                }
                
                var aa = Array<[String: Double]>()
                for i in 0..<self.dateList.count {
                    aa.append([self.dateList[i]: self.endList[i]])
                }

                var resultDicts: [[String: Double]] = []
                var uniqueKeys: Set<String> = []
                
                for dict in aa.reversed() {
                    guard let (key, value) = dict.first, !uniqueKeys.contains(key) else {
                        continue
                    }
                    uniqueKeys.insert(key)
                    resultDicts.append([key: value])
                }

                    self.dateList = []
                    self.endList = []
                
                resultDicts.reversed().map {
                    self.dateList.append(contentsOf: $0.keys)
                    self.endList.append(contentsOf: $0.values)
                }
        
            }
            .store(in: &bag)
        }
    }
}
