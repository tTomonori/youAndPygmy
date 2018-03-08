//
//  SaveData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/09.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
//セーブデータ管理
class SaveData{
    private static var mMapName:String!
    private static var mPosition:FeildPosition!
    private static var mAccompanying:[AccompanyingData]!
    private static var mEncountCount:Int=5
    static func load(){
        mMapName="debug3"
        mPosition=FeildPosition(x:1,y:1,z:1)
        mAccompanying=[
                    AccompanyingData(
                        name:"みう",
                        raceName:"myutansu",
                        personal:Status(
                            hp:2,
                            mp:1,
                            atk:1,
                            def:1,
                            int:1,
                            spt:1,
                            dex:1,
                            spd:1,
                            pie:1
                        ),
                        level:10,
                        currentHp:10,
                        setedSkills:[0,2,3],
                        masteredSkills:["sougeki","kyuuketu","kansen","kansengen"],
                        item:"tiisanakinomi",
                        itemNum:3,
                        accessory:"kanzasi"
            )
        ]
    }
    //主人公がいるマップ名
    static func getMapName()->String{return mMapName}
    //主人公がいる座標
    static func getPosition()->FeildPosition{return mPosition}
    //手持ちぴぐみー
    static func getAccompanying()->[AccompanyingData]{return mAccompanying}
    //エンカウント判定
    static func countEncount()->Bool{
        if(mEncountCount<=1){
            mEncountCount=5
            return true
        }
        else{
            mEncountCount-=1
            return false
        }
    }
}