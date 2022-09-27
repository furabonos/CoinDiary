//
//  AddDataSource.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseCore


public protocol AddDataSourceInterface {
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?,
                  completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class AddDataSource: AddDataSourceInterface {
    
    public func saveData(date: String, start: String, end: String, memo: String, image: UIImage?,completion: @escaping (Bool) -> Void) -> Cancellable? {
        
        if image == nil {
            let task = RepositoryTask()
            let db = Firestore.firestore()
            db.collection(UserDefaults.standard.string(forKey: "UUID")!).document(date).setData([
                "start": start,
                "end": end,
                "memo": memo,
                "today": date
            ]) { (error) in
                if error == nil {
                    completion(true)
                }else {
                    completion(false)
                }
            }
            return task
        }else {
            guard let imageData = image!.jpegData(compressionQuality: 0.4) else { return }
            let metaData = Storage.storage()
        }
        
//        let task = RepositoryTask()
//        let db = Firestore.firestore()
//        db.collection(UserDefaults.standard.string(forKey: "UUID")!).document(date).setData([
//            "start": start,
//            "end": end,
//            "memo": memo,
//            "today": date
//        ]) { (error) in
//            if error == nil {
//                completion(true)
//            }else {
//                completion(false)
//            }
//        }
//        return task
    }
    
    
}
