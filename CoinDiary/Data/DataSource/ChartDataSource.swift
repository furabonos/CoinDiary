//
//  ChartDataSource.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/18.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage

public protocol ChartDataSourceInterface {
    func fetchData(completion: @escaping (AnyPublisher<[[String]], Error>) -> Void)
}

public final class ChartDataSource: ChartDataSourceInterface {
    public func fetchData(completion: @escaping (AnyPublisher<[[String]], Error>) -> Void) {
        let db = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "UUID")!)
        let decoder = JSONDecoder()
        var dateArr = Array<String>()
        var endArr = Array<String>()
        
        completion(
            Future<[[String]], Error> { promise in
                db.order(by: "today", descending: false).getDocuments { documents, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let documents = documents {
                        for document in documents.documents {
                            do {
                                let datas = document.data()
                                let jsonData = try JSONSerialization.data(withJSONObject: datas)
                                let dtoData = try decoder.decode(DiaryDTO.self, from: jsonData)
                                dateArr.append(dtoData.today)
                                endArr.append(dtoData.end)
                            } catch let error {
                                promise(.failure(error))
                            }
                        }
                        promise(.success([dateArr, endArr]))
                    }
                }
            }.eraseToAnyPublisher()
        )
    }
}
