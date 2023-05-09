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
    let type: String?
    let register: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL, memo, start, end, today, type, register
    }
    
    public func dto() -> DiaryEntity {
        return DiaryEntity(imageURL: imageURL, memo: memo, start: start, end: end, today: today, types: type, register: register)
    }
}
