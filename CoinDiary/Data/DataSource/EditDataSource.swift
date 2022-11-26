//
//  EditDataSource.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import Foundation

import Combine
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage

public protocol EditDataSourceInterface {
    func saveData(date: String, start: String, end: String, memo: String, image: UIImage?,
                  completion: @escaping (Bool) -> Void) -> Cancellable?
    func removeData(date: String, completion: @escaping (Bool) -> Void) -> Cancellable?
}

public final class EditDataSource: EditDataSourceInterface {
    
    public func saveData(date: String, start: String, end: String, memo: String, image: UIImage?,completion: @escaping (Bool) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        let db = Firestore.firestore()
        
        if image == nil {
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
            let storage = Storage.storage()
            let imageData = image!.jpegData(compressionQuality: 0.8)!
            let metaData = StorageMetadata()
            let fileName = "\(Date().getToday)"
            let reference = storage.reference().child(UserDefaults.standard.string(forKey: "UUID")!).child(fileName)
            metaData.contentType = "image/png"
            
            reference
                .putData(imageData, metadata: metaData){
                    (metaData,error) in if let error = error { //실패
                        print("에러에러 = \(error)")
                        completion(false)
                    }else{ //성공
                        print("일단 사진업로드성공")
                        reference.downloadURL { url, _ in
                            let urlString = url!.absoluteString
                            db.collection(UserDefaults.standard.string(forKey: "UUID")!).document(date).setData([
                                "start": start,
                                "end": end,
                                "memo": memo,
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
    
    public func removeData(date: String, completion: @escaping (Bool) -> Void) -> Cancellable? {
        let db = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "UUID")!).document(date)
        let task = RepositoryTask()
        
        db.delete { error in
            if let error = error {
                completion(false)
            }else {
                completion(true)
            }
        }
        return task
    }
    
}
