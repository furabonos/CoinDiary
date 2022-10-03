//
//  DiaryDataSource.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/17.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage

public protocol DiaryDataSourceInterface {
    func fetchData(completion: @escaping (AnyPublisher<[DiaryDTO], Error>) -> Void)
    func addSnapshot(completion: @escaping (AnyPublisher<DiaryDTO, Error>) -> Void)
}

public final class DiaryDataSource: DiaryDataSourceInterface {
    
    public func fetchData(completion: @escaping (AnyPublisher<[DiaryDTO], Error>) -> Void) {
        let db = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "UUID")!)
        let decoder = JSONDecoder()
        
        completion(
            Future<[DiaryDTO], Error> { promise in
                db.order(by: "today", descending: true).getDocuments { documents, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let documents = documents {
                        var diaries = [DiaryDTO]()
                        for document in documents.documents {
                            do {
                                let datas = document.data()
                                let jsonData = try JSONSerialization.data(withJSONObject: datas)
                                let dtoData = try decoder.decode(DiaryDTO.self, from: jsonData)
                                diaries.append(dtoData)
                            } catch let error {
                                promise(.failure(error))
                            }
                        }
                        promise(.success(diaries))
                    }
                }
            }.eraseToAnyPublisher()
        )
        
    }
    
    public func addSnapshot(completion: @escaping (AnyPublisher<DiaryDTO, Error>) -> Void) {
        let db = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "UUID")!).document(Date().getToday)
        let decoder = JSONDecoder()
        
        completion(
            Future<DiaryDTO, Error> { promise in
                db.addSnapshotListener { documents, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let documents = documents {
                        var diary = [DiaryDTO]()
                        do {
                            guard let datas = documents.data() else { return }
                            let jsonData = try JSONSerialization.data(withJSONObject: datas)
                            let dtoData = try decoder.decode(DiaryDTO.self, from: jsonData)
                            diary.append(dtoData)
                        }catch let error {
                            promise(.failure(error))
                        }
                        promise(.success(diary[0]))
                    }
                }
            }.eraseToAnyPublisher()
        )
    }
    
    
}
