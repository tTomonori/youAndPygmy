//
//  RaceData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

//キャラ情報
class RaceData :NSObject{
    let raceKey:String//種族名(キー名)
    let raceName:String//種族名(表示名)
    let raceStatus:Status//種族値
    let mobility:Mobility//移動力
    let image:CharaImageData//画像
    let skills:[(Int,String)]//習得するスキル(習得レベル,スキル名)
    let ai:AiType//行動パターン
    init(
        raceKey:String,
         raceName:String,
         raceStatus:Status,
         mobility:Mobility,
         image:CharaImageData,
         skills:[(Int,String)],
         ai:AiType
        ){
        self.raceKey=raceKey
        self.raceName=raceName
        self.raceStatus=raceStatus
        self.mobility=mobility
        self.image=image
        self.skills=skills
        self.ai=ai
    }
}

//キャラの画像データ
class CharaImageData{
    private let mBody:Dictionary<String,String>?
    private let mEye:Dictionary<String,String>?
    private let mMouth:Dictionary<String,String>?
    private let mAccessory:String?
    init(body:Dictionary<String,String>?,eye:Dictionary<String,String>?,mouth:Dictionary<String,String>?){
        mBody=body
        mEye=eye
        mMouth=mouth
        mAccessory=nil
    }
    init(body:Dictionary<String,String>?,eye:Dictionary<String,String>?,mouth:Dictionary<String,String>?,accessory:String){
        mBody=body
        mEye=eye
        mMouth=mouth
        mAccessory=accessory
    }
    init(base:CharaImageData,accessory:String?){
        mBody=base.mBody
        mEye=base.mEye
        mMouth=base.mMouth
        
        if(accessory==nil){mAccessory=nil}
        else if(accessory! == ""){mAccessory=nil}
        else{mAccessory=accessory}
    }
    //画像名取得
    func get(parts:String,pattern:String)->String?{
        switch parts {
        case "body":return (mBody==nil) ?nil:mBody![pattern]
        case "eye":return (mEye==nil) ?nil:mEye![pattern]
        case "mouth":return (mMouth==nil) ?nil:mMouth![pattern]
        case "accessory":return mAccessory
        default:print("不正な部位名",parts)
        }
        return nil
    }
    //アクセサリの画像名取得
    func getAccessory()->String?{
        return mAccessory
    }
    //部位ごとにまとめて取得
    func getDictionary(parts:String)->Dictionary<String,String>?{
        switch parts {
        case "body":return mBody
        case "eye":return mEye
        case "mouth":return mMouth
        default:print("不正な部位名",parts)
        }
        return nil
    }
}
