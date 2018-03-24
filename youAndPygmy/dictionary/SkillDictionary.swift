//
//  SkillDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SkillDictionary:NSObject{
    static func get(_ key:String)->SkillData{
        return self.value(forKey: key) as! SkillData
    }
}

class SkillData:NSObject{
    let name:String//スキル名
    let details:String//詳細説明
    let category:SkillCategory//物理or魔法or支援or回復orパッシブ
    let type:SkillType//属性
    let mp:Int//消費やる気
    let counter:Bool//反撃スキルかどうか
    let power:Int!//威力
    let range:SkillRange!//攻撃範囲
    let accuracy:Int!//命中率
    init(
        name:String,
        details:String,
        category:SkillCategory,
        type:SkillType,
        mp:Int,
        counter:Bool,
        power:Int,
        range:SkillRange,
        accuracy:Int
        ){
        self.name=name
        self.details=details
        self.category=category
        self.type=type
        self.mp=mp
        self.counter=counter
        self.power=power
        self.range=range
        self.accuracy=accuracy
    }
    //パッシブスキル用
    init(
        name:String,
        details:String,
        category:SkillCategory,
        type:SkillType
        ){
        self.name=name
        self.details=details
        self.category=category
        self.type=type
        self.mp=0
        self.counter=false
        self.power=nil
        self.range=nil
        self.accuracy=nil
    }
}

enum SkillCategory {
    case physics//物理
    case magic//魔法
    case disturbance//妨害
    case assist//支援
    case heal//回復
    case passive//パッシブ
    func name()->String{
        switch self {
        case .physics:return "物理"
        case .magic:return "魔法"
        case .disturbance:return "妨害"
        case .assist:return "支援"
        case .heal:return "回復"
        case .passive:return "特性"
        }
    }
}
enum SkillType{
    case zan//斬
    case totu//突
    case da//打
    case hi//火
    case water//水
    case nature//自然
    case sei//聖
    case ja//邪
}
//スキルの攻撃範囲
struct SkillRange{
    let rangeType:SkillRangeType
    let range:Int!
    init(type:SkillRangeType,range:Int){
        self.rangeType=type
        self.range=range
    }
    init(type:SkillRangeType){
        self.rangeType=type
        self.range=nil
    }
}
enum SkillRangeType{
    case adjacent//隣接マス
    case adjacentIncludeMyself//自身と隣接マス
    case range//射程
    case rangeIncludeMyself//自分を含む射程
    case circumference//周囲
    case circumferenceIncludeMyself//自分を含む周囲
    case myself//自身
    case line//直線
}
