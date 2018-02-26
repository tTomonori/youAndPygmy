//
//  PygmyDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class PygmyDictionary : NSObject{
    static func get(key:String)->RaceData{
        return self.value(forKey: key) as! RaceData
    }
}

//キャラ情報
class RaceData :NSObject{
    let key:String//種族名(キー名)
    let name:String//種族名(表示名)
    let raceStatus:Status//種族値
    let mov:Int//移動力
    let moc:Dictionary<String,Double>//移動コスト
    let image:Dictionary<String,String>//画像
    init(key:String,name:String,raceStatus:Status,mov:Int,moc:Dictionary<String,Double>,image:Dictionary<String,String>){
        self.key=key
        self.name=name
        self.raceStatus=raceStatus
        self.mov=mov
        self.moc=moc
        self.image=image
    }
}

/*
 extension PygmyDictionary{
 static let =RaceData(
 race:"",
 name:"",
 raceStatus:Status(
 hp:,
 mp:,
 atk:,
 def:,
 int:,
 spt:,
 dex:,
 spd:,
 pie:
 ),
 mov:,
 moc:[
 "grass":,
 "sand":,
 "water":,
 "magma":,
 "snow":,
 "ice":,
 "air":
 ],
 image:[
 "body":"",
 "eye":"",
 "mouth":""
 ]
 )
 }
 */
