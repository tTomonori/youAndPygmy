//
//  AccessoryDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/26.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class AccessoryDictionary:NSObject{
    static func get(_ key:String)->AccessoryData{
        return self.value(forKey: key) as! AccessoryData
    }
}

class AccessoryData:NSObject{
    let name:String//アクセサリ名
    let text:String//詳細説明
    let image:String//画像名
    let status:Status//ステータス補正値
    let skill:String?//付与スキル
    let type:AccessoryType//アクセサリタイプ
    init(
        name:String,
        text:String,
        image:String,
        status:Status,
        skill:String?,
        type:AccessoryType
        ){
        self.name=name
        self.text=text
        self.image=image
        self.status=status
        self.skill=skill
        self.type=type
    }
}

struct AccessoryType{
    let attribute:[AccessoryAttribute]
    init(_ aAttribute:[AccessoryAttribute]){
        self.attribute=aAttribute
    }
    func include(_ aType:AccessoryType)->Bool{
        for tAttribute in aType.attribute{
            if(!self.attribute.contains(tAttribute)){
                return false
            }
        }
        return true
    }
}
enum AccessoryAttribute{
    case zan//斬
    case totu//突
    case da//打
    case ja//邪
    case kasi//菓子
}
