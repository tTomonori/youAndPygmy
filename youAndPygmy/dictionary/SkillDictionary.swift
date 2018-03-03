//
//  SkillDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SkillDictionary:NSObject{
    static func get(key:String)->SkillData{
        return self.value(forKey: key) as! SkillData
    }
}

class SkillData:NSObject{
    let name:String//スキル名
    let category:SkillCategory//物理or魔法or支援or回復orパッシブ
    init(
        name:String,
        category:SkillCategory
        ){
        self.name=name
        self.category=category
    }
}

enum SkillCategory {
    case physics//物理
    case magic//魔法
    case assist//支援
    case heal//回復
    case passive//パッシブ
}
