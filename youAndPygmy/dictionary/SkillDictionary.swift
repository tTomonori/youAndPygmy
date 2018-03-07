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
    let type:SkillType//属性
    init(
        name:String,
        category:SkillCategory,
        type:SkillType
        ){
        self.name=name
        self.category=category
        self.type=type
    }
}

enum SkillCategory {
    case physics//物理
    case magic//魔法
    case assist//支援
    case heal//回復
    case passive//パッシブ
}
enum SkillType{
    case zan//斬
    case totu//突
    case da//打
    case hi//火
    case water//水
    case sei//聖
    case ja//邪
}
