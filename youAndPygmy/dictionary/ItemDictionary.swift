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
    init(
        name:String,
        maxNum:Int
        ){
        self.name=name
        self.maxNum=maxNum
    }
}
