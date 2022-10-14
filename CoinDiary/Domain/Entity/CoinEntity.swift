//
//  CoinEntity.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/14.
//

import Foundation

public struct CoinEntity: Hashable, Identifiable {
    
    public var id = UUID()
    public let imageURL: String?
    public let memo: String?
    public let start: String
    public let end: String
    public let today: String
    
    public init(imageURL: String?, memo: String?, start: String, end: String, today: String)
    {
        self.imageURL = imageURL
        self.memo = memo
        self.start = start
        self.end = end
        self.today = today
    }
}
