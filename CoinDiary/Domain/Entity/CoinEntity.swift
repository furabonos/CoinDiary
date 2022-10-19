//
//  CoinEntity.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/14.
//

import Foundation

public struct Coin: Equatable, Identifiable {
    public var id = UUID()
     let symbol: String
     let contractType: String
}

public struct CoinEntity: Equatable, Identifiable {
    public var id = UUID()
    let symbols: [Coin]
}
