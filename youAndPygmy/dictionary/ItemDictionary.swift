//
//  ItemDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/26.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class ItemDictionary:NSObject{
    static func get(key:String)->ItemData{
        return self.value(forKey: key) as! ItemData
    }
}

class ItemData:NSObject{
    let name:String//アイテム名
    let maxNum:Int//同時に持てる最大数
    let effectKey:String//戦闘中に使用した時の効果
    init(
        name:String,
        maxNum:Int,
        effectKey:String
        ){
        self.name=name
        self.maxNum=maxNum
        self.effectKey=effectKey
    }
}
