//
//  AccessoryDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/26.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class AccessoryDictionary:NSObject{
    static func get(key:String)->AccessoryData{
        return self.value(forKey: key) as! AccessoryData
    }
}

class AccessoryData:NSObject{
    let name:String//アクセサリ名
    let image:String//画像名
    init(name:String,image:String){
        self.name=name
        self.image=image
    }
}

enum AccessoryType{
    case zan
    case totu
    case da
}
