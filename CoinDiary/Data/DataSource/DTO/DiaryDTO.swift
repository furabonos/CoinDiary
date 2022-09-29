//
//  DiaryDTO.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import Foundation

public struct DiaryDTO: Codable {

    let imageURL: String?
    let memo: String?
    let start: String
    let end: String
    let today: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL, memo, start, end, today
    }
    
//    public func dto() -> UserEntity {
//        return UserEntity(id: login)
//    }
}
