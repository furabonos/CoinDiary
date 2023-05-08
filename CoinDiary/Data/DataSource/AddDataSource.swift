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
import FirebaseStorage

public protocol AddDataSourceInterface {
    func saveData(date: String, start: String, end: String, memo: String, type: String, image: UIImage?,
                  completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class AddDataSource: AddDataSourceInterface {
    
    public func saveData(date: String, start: String, end: String, memo: String, type: String, image: UIImage?, completion: @escaping (Bool) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        let db = Firestore.firestore()
        
        if image == nil {
            db.collection(UserDefaults.standard.string(forKey: "UUID")!).document(date).setData([
                "start": start,
                "end": end,
                "memo": memo,
                "type": type,
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
            let storage = Storage.storage()
            let imageData = image!.jpegData(compressionQuality: 0.8)!
            let metaData = StorageMetadata()
            let fileName = "\(Date().getToday)"
            let reference = storage.reference().child(UserDefaults.standard.string(forKey: "UUID")!).child(fileName)
            metaData.contentType = "image/png"
            
            reference
                .putData(imageData, metadata: metaData){
                    (metaData,error) in if let error = error { //실패
                        completion(false)
                    }else{ //성공
                        reference.downloadURL { url, _ in
                            let urlString = url!.absoluteString
                            db.collection(UserDefaults.standard.string(forKey: "UUID")!).document(date).setData([
                                "start": start,
                                "end": end,
                                "memo": memo,
                                "type": type,
                                "today": date,
                                "imageURL": urlString
                            ]) { (error) in
                                if error == nil {
                                    completion(true)
                                }else {
                                    completion(false)
                                }
                            }
                        }
                        
                    }
                }
        }
                return task
    }
    
    
}
