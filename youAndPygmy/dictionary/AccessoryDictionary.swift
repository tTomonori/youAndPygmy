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
    init(name:String){
        self.name=name
    }
}
