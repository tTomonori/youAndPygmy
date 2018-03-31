//
//  ItemDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/26.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class ItemDictionary:NSObject{
    static func get(_ key:String)->ItemData{
        return self.value(forKey: key) as! ItemData
    }
}

class ItemData:NSObject{
    let name:String//アイテム名
    let text:String//詳細説明
    let useEffect:UseEffect?//マップで使用した時の効果
    let maxNum:Int//同時に持てる最大数
    let effectKey:String!//戦闘中に使用した時の効果
    init(
        name:String,
        text:String,
        useEffect:UseEffect?,
        maxNum:Int,
        effectKey:String?
        ){
        self.name=name
        self.text=text
        self.useEffect=useEffect
        self.maxNum=maxNum
        self.effectKey=effectKey
    }
}

//アイテムの効果
struct UseEffect{
    let effect:ItemEffect!//効果
    let option:Dictionary<String,Any>
    //回復効果
    init(healType:String,correction:PowerCorrectType,value:Int) {
        switch healType {
        case "all":self.effect = .allHeal
        case "one":self.effect = .oneHeal
        default:
            print("回復効果がおかしいよ→",healType)
            self.effect=nil
        }
        self.option=["correction":correction,"value":value]
    }
}
enum ItemEffect{
    case allHeal//全体回復
    case oneHeal//一人回復
}
