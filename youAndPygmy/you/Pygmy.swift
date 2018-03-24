//
//  Pygmy.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Pygmy{
    private var mName:String//名前
    private var mRaceData:PygmyRaceData//種族値+α
    private var mPersonal:Status//個性値
    private var mLevel:Int//レベル
    private var mStatus:Status//ステータス
    private var mCurrentHp:Int//現在hp
    private var mSettedSkills:[Int]//セットしたスキル
    private var mMasteredSkills:[String?]//習得しているスキル
    private var mItem:String//持ち物
    private var mItemNum:Int//持ち物の数
    private var mAccessory:String//アクセサリ
    init(aData:AccompanyingData){
        mName=aData.name
        mRaceData=PygmyDictionary.get(key:aData.raceName)
        mPersonal=aData.personal
        mLevel=aData.level
        mStatus=StatusCalcurator.calcurate(aRaceStatus:mRaceData.raceStatus,aLevel:mLevel,aPersonality:mPersonal)
        mCurrentHp=aData.currentHp
        mSettedSkills=aData.setedSkills
        mMasteredSkills=aData.masteredSkills
        mItem=aData.item
        mItemNum=aData.itemNum
        mAccessory=aData.accessory
    }
    //データ取得
    func getName()->String{return mName}
    func getRaceData()->PygmyRaceData{return mRaceData}
    func getLevel()->Int{return mLevel}
    func getStatus()->Status{return mStatus}
    func getCurrentHp()->Int{return mCurrentHp}
    func getExperience()->Int{return 65}
    func getNextExperience()->Int{return 100}
    func getMasteredSkills()->[String?]{return mMasteredSkills}
    func getNatureSkill()->String?{return mRaceData.natureSkill}
    func getItem()->(String,Int){return (mItem,mItemNum)}
    func getAccessory()->String{return mAccessory}
    func getImage()->CharaImageData{
        if(mAccessory != ""){//アクセサリあり
            return CharaImageData.init(base:mRaceData.image,accessory:AccessoryDictionary.get(key:mAccessory).image)
        }
        return CharaImageData.init(base:mRaceData.image,accessory:nil)
    }
    //装備スキル取得
    func getSettedSkills()->[String?]{
        var tSettedSkills:[String?]=[]
        for i in mSettedSkills{
            if(i == -1){tSettedSkills.append(nil)}
            else{tSettedSkills.append(mMasteredSkills[i])}
        }
        return tSettedSkills
    }
    //戦闘で使えるスキル取得
    func getBattleSkills()->[String]{
        var tSkills:[String]=[]
        for tNum in mSettedSkills{
            if(tNum == -1){continue}
            tSkills.append(mMasteredSkills[tNum]!)
        }
        return tSkills
    }
    //ステータスの補正値を返す
    func getCorrection()->Status{
        return Status(hp:0,mp:0,atk:0,def:0,int:0,spt:0,dex:0,spd:0,pie:0)
    }
    //補正値込みのステータスを返す
    func getCorrectedStatus()->Status{
        return mStatus
    }
    //補正値込みの移動力を返す
    func getCorrectedMobility()->Mobility{
        return mRaceData.mobility
    }
}
