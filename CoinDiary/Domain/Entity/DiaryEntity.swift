//
//  DiaryEntity.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import Foundation

public struct DiaryEntity: Hashable, Identifiable {
    
    public var id = UUID()
    public let imageURL: String?
    public let memo: String?
    public let start: String
    public let end: String
    public let today: String
    public let types: String?
    public let register: String
    
    public init(imageURL: String?, memo: String?, start: String, end: String, today: String, types: String?, register: String)
    {
        self.imageURL = imageURL
        self.memo = memo
        self.start = start
        self.end = end
        self.today = today
        self.types = types
        self.register = register
    }
}


