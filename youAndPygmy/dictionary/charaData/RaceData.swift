//
//  RaceData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

//キャラ情報
class RaceData :NSObject{
    let raceKey:String//種族名(キー名)
    let raceName:String//種族名(表示名)
    let raceStatus:Status//種族値
    let mobility:Mobility//移動力
    let image:CharaImageData//画像
    let skills:[(Int,String)]//習得するスキル(習得レベル,スキル名)
    let natureSkill:String?//天性特性
    let ai:AiType//行動パターン
    init(
        raceKey:String,
         raceName:String,
         raceStatus:Status,
         mobility:Mobility,
         image:CharaImageData,
         skills:[(Int,String)],
         natureSkill:String?,
         ai:AiType
        ){
        self.raceKey=raceKey
        self.raceName=raceName
        self.raceStatus=raceStatus
        self.mobility=mobility
        self.image=image
        self.skills=skills
        self.natureSkill=natureSkill
        self.ai=ai
    }
}

//キャラの画像データ
class CharaImageData{
    private let mBody:Dictionary<String,UIImage>?
    private let mEye:Dictionary<String,UIImage>?
    private let mMouth:Dictionary<String,UIImage>?
    private let mAccessory:UIImage?
    init(body:Dictionary<String,String>!=nil,eye:Dictionary<String,String>!=nil,mouth:Dictionary<String,String>!=nil,accessory:String?=nil){
        //体
        if(body != nil){
        var tBody:Dictionary<String,UIImage>=[:]
        for (tPattern,tImageName) in body{
            tBody[tPattern]=UIImage(named:tImageName)!
        }
        mBody=tBody
        }
        else{mBody=nil}
        //目
        if(eye != nil){
        var tEye:Dictionary<String,UIImage>=[:]
        for (tPattern,tImageName) in eye{
            tEye[tPattern]=UIImage(named:tImageName)!
        }
        mEye=tEye
        }
        else{mEye=nil}
        //口
        if(mouth != nil){
        var tMouth:Dictionary<String,UIImage>=[:]
        for (tPattern,tImageName) in mouth{
            tMouth[tPattern]=UIImage(named:tImageName)!
        }
        mMouth=tMouth
        }
        else{mMouth=nil}
        //アクセサリ
        mAccessory=(accessory==nil) ?nil:AccessoryDictionary.get(accessory!).image
    }
    init(base:CharaImageData,accessory:String?){
        mBody=base.mBody
        mEye=base.mEye
        mMouth=base.mMouth
        mAccessory=(accessory==nil) ?nil:AccessoryDictionary.get(accessory!).image
    }
    //画像名取得
    func get(parts:String,pattern:String)->UIImage?{
        switch parts {
        case "body":return mBody?[pattern]
        case "eye":return mEye?[pattern]
        case "mouth":return mMouth?[pattern]
        case "accessory":return mAccessory
        default:print("不正な部位名",parts)
        }
        return nil
    }
    //アクセサリの画像取得
    func getAccessory()->UIImage?{
        return mAccessory
    }
    //部位ごとにまとめて取得
    func getPartsImages(parts:String)->Dictionary<String,UIImage>?{
        switch parts {
        case "body":return mBody
        case "eye":return mEye
        case "mouth":return mMouth
        default:print("不正な部位名",parts)
        }
        return nil
    }
}
