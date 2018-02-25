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
    static func load(){
        mMapName="debug"
        mPosition=FeildPosition(x:7,y:1,z:4)
//        mPosition=FeildPosition(x:0,y:0,z:1)
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
                        setSkills:[],
                        masteredSkills:[],
                        item:"",
                        itemNum:0,
                        accessory:""
            )
        ]
    }
    //主人公がいるマップ名
    static func getMapName()->String{return mMapName}
    //主人公がいる座標
    static func getPosition()->FeildPosition{return mPosition}
    //手持ちぴぐみー
    static func getAccompanying()->[AccompanyingData]{return mAccompanying}
}
