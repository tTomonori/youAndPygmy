//
//  you.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class You{
    //手持ちぴぐみー
    private static var mAccompanying:[Pygmy]!
    private static var mMaxAccompanyingNum=5
    //手持ちぴぐみーセット
    static func setAccompanying(aAccompanying:[Pygmy]){
        if(aAccompanying.count>mMaxAccompanyingNum){print("そんなに連れ歩けないよ",aAccompanying);return}
        mAccompanying=aAccompanying
    }
    //手持ちぴぐみー取得
    static func getAccompanying()->[Pygmy]{
        return mAccompanying
    }
}

struct AccompanyingData{
    var name:String//名前
    let raceName:String//種族名
    var personal:Status//個性値
    var level:Int//レベル
    var currentHp:Int//現在hp
    var setSkills:[String]//セットしたスキル
    var masteredSkills:[String]//習得しているスキル
    var item:String//持ち物
    var itemNum:Int//持ち物の数
    var accessory:String//アクセサリ
}
