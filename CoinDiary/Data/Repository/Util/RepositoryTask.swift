//
//  RepositoryTask.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/26.
//

import Foundation

class RepositoryTask: Cancellable {
    var isCancelled: Bool = false
    
    func cancel() {
        isCancelled = true
    }
}
