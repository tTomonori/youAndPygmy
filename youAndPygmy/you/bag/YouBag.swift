//
//  YouBag.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/27.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class YouBag{
    static let toolBag=Bag([])
    static let accessoryBag=Bag([])
    static let importantBag=Bag([])
    static let fragmentBag=Bag([])
    static func getBag(_ aCategory:ItemCategory)->Bag{
        switch aCategory {
        case .tool:return toolBag
        case .accessory:return accessoryBag
        case .important:return importantBag
        case .fragment:return fragmentBag
        }
    }
}

enum ItemCategory{
    case tool//どうぐ
    case accessory//アクセサリ
    case important//大切なもの
    case fragment//カケラ
}
