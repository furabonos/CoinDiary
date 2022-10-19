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
                        diaries.removeAll()
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
        let db = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "UUID")!)
        let decoder = JSONDecoder()
        var diary = [DiaryDTO]()
        
        completion(
            Future<DiaryDTO, Error> { promise in
                db.addSnapshotListener { documents, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let documents = documents {
                        documents.documentChanges.forEach { change in
                            switch change.type {
                            case .added, .modified:
                                print("add, modi? = \(change.type), valueS~ = \(change.document.data())")
                                do {
                                    let datas = change.document.data()
                                    let jsonData = try JSONSerialization.data(withJSONObject: datas)
                                    let dtoData = try decoder.decode(DiaryDTO.self, from: jsonData)
                                    print("왜안탐시발;; = \(dtoData)")
                                    diary.append(dtoData)
                                }catch let error {
                                    promise(.failure(error))
                                }
                            default:
                                break
                            }
                            promise(.success(diary[0]))
                        }
                    }
                }
            }.eraseToAnyPublisher()
        )
    }
    
    
}
