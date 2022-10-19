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

extension CoinDTO {
    struct Symbols: Codable {
        let symbol: String
        let contractType: String
        
        
        enum CodingKeys: String, CodingKey {
            case symbol, contractType
        }
    }
}

extension CoinDTO {
    func toDomain() -> CoinEntity {
        return .init(symbols: symbols.map { $0.toDomain() })
    }
}

extension CoinDTO.Symbols {
    func toDomain() -> Coin{
        return .init(symbol: symbol, contractType: contractType)
    }
}
