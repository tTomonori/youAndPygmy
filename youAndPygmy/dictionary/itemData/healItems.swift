//
//  healItems.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension ItemDictionary{
    static let tiisanakinomi=ItemData(
        name:"小さなきのみ",
        text:"小さなきのみ。ぴぐみーの元気を10回復する。",
        useEffect:UseEffect.init(healType:"one",correction:.constant,value:10),
        maxNum:5,
        effectKey:"tiisanakinomi"
    )
    static let itigotaruto=ItemData(
        name:"苺タルト",
        text:"苺をふんだんに使ったタルト。ぴぐみーの元気を20回復する。",
        useEffect:UseEffect.init(healType:"all",correction:.constant,value:20),
        maxNum:0,
        effectKey:nil
    )
}
