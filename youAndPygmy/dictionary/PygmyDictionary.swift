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
    let raceKey:String//種族名(キー名)
    let raceName:String//種族名(表示名)
    let raceStatus:Status//種族値
    let mobility:Mobility//移動力
    let image:Dictionary<String,String>//画像
    init(raceKey:String,raceName:String,raceStatus:Status,mobility:Mobility,image:Dictionary<String,String>){
        self.raceKey=raceKey
        self.raceName=raceName
        self.raceStatus=raceStatus
        self.mobility=mobility
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
