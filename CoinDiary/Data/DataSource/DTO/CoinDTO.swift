//
//  CoinDTO.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/14.
//

import Foundation

public struct CoinDTO: Codable {

    let symbols: [Symbols]
    
    enum CodingKeys: String, CodingKey {
        case symbols
    }
}

public struct Symbols: Codable {
    let symbol: String
    let contractType: String
    
    
    enum CodingKeys: String, CodingKey {
        case symbol, contractType
    }
}
