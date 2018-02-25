//
//  MapData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class MapDictionary : NSObject{
    static func get(aMapName:String)->MapData{
        return MapDictionary.value(forKey: aMapName) as! MapData
    }
}

//マップのデータ
class MapData : NSObject{
    let troutData:Dictionary<Int,Dictionary<Int,[Float]>>
    let chipData:Dictionary<Int,Dictionary<String,Any>>
    let npcData:[NpcData]
    let specialTrout:[Dictionary<String,Any>]
    init(troutData:Dictionary<Int,Dictionary<Int,[Float]>>,
         chipData:Dictionary<Int,Dictionary<String,Any>>,
         npcData:[NpcData],
         specialTrout:[Dictionary<String,Any>]){
        self.troutData=troutData
        self.chipData=chipData
        self.npcData=npcData
        self.specialTrout=specialTrout
    }
}
//マップ上のnpcデータ
struct NpcData{
    let name:String
    let position:FeildPosition
    let imageName:String
    let direction:String
    let speakEvents:[Dictionary<String,Any>]
}
