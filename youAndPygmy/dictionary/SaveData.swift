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
    private static var mToolBag:[(String,Int)]!
    private static var mAccessoryBag:[(String,Int)]!
    private static var mImportantBag:[(String,Int)]!
    private static var mFragMentBag:[(String,Int)]!
    //セーブデータを読み込む
    static func load(){
        mMapName="debug3"
        mPosition=FeildPosition(x:1,y:1,z:1)
        mAccompanying=[
                    AccompanyingData(
                        name:"みう",
                        raceName:"myutansu",
                        personal:Status(
                            hp:2,
                            mp:2,
                            atk:1,
                            def:1,
                            ini:1,
                            spt:1,
                            dex:1,
                            spd:1,
                            pie:2
                        ),
                        level:12,
                        currentHp:35,
                        setedSkills:["sougeki","kansen",nil,"kansengen"],
                        masteredSkills:["sougeki","kansen","kansengen",nil],
                        item:"tiisanakinomi",
                        itemNum:3,
                        accessory:"kanzasi"
            ),
                    AccompanyingData(
                        name:"みー",
                        raceName:"myutansu",
                        personal:Status(
                            hp:1,
                            mp:1,
                            atk:5,
                            def:0,
                            ini:0,
                            spt:0,
                            dex:0,
                            spd:0,
                            pie:0
                        ),
                        level:7,
                        currentHp:15,
                        setedSkills:["sougeki","kansen",nil,nil],
                        masteredSkills:["sougeki","kansen",nil,nil],
                        item:nil,
                        itemNum:0,
                        accessory:nil
            ),
                    AccompanyingData(
                        name:"うさち",
                        raceName:"yukiusagi",
                        personal:Status(
                            hp:1,
                            mp:1,
                            atk:0,
                            def:0,
                            ini:2,
                            spt:1,
                            dex:0,
                            spd:0,
                            pie:2
                        ),
                        level:10,
                        currentHp:25,
                        setedSkills:["konayuki","ziai",nil,nil],
                        masteredSkills:["tataku","ziai","konayuki",nil],
                        item:nil,
                        itemNum:0,
                        accessory:nil
            )
        ]
        mToolBag=[("tiisanakinomi",25),("itigotaruto",5)]
        mAccessoryBag=[("kanzasi",3)]
        mImportantBag=[]
        mFragMentBag=[]
    }
    //読み込んだデータでゲーム開始
    static func setData(){
        //マップ設定
        MapFeild.setMap(aMapData:MapDictionary.get(mMapName))
        //自キャラ配置
        MapFeild.initHero(aPosition:mPosition)
        MapFeild.makeCameraFollowHero()
        MapFeild.display()
        MapUi.display()
        //手持ちぴぐみー設定
        var tPygmies:[Pygmy]=[]
        for tData in mAccompanying{
            tPygmies.append(Pygmy(aData:tData))
        }
        You.setAccompanying(aAccompanying:tPygmies)
        //持ち物
        YouBag.toolBag.set(mToolBag)
        YouBag.accessoryBag.set(mAccessoryBag)
        YouBag.importantBag.set(mImportantBag)
        YouBag.fragmentBag.set(mFragMentBag)
    }
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
