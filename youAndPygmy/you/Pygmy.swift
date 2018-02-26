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
    private var mRaceData:RaceData//種族値+α
    private var mPersonal:Status//個性値
    private var mLevel:Int//レベル
    private var mStatus:Status//ステータス
    private var mCurrentHp:Int//現在hp
    private var mSettedSkills:[String]//セットしたスキル
    private var mMasteredSkills:[String]//習得しているスキル
    private var mItem:ItemData?//持ち物
    private var mItemNum:Int//持ち物の数
    private var mAccessory:AccessoryData?//アクセサリ
    init(aData:AccompanyingData){
        mName=aData.name
        mRaceData=PygmyDictionary.get(key:aData.raceName)
        mPersonal=aData.personal
        mLevel=aData.level
        mStatus=StatusCalcurator.calcurate(aRaceStatus:mRaceData.raceStatus,aLevel:mLevel,aPersonality:mPersonal)
        mCurrentHp=aData.currentHp
        mSettedSkills=aData.setSkills
        mMasteredSkills=aData.masteredSkills
        mItem=(aData.item != "") ? ItemDictionary.get(key:aData.item):nil
        mItemNum=aData.itemNum
        mAccessory=(aData.accessory != "") ? AccessoryDictionary.get(key:aData.accessory):nil
    }
    //データ取得
    func getName()->String{return mName}
    func getRaceData()->RaceData{return mRaceData}
    func getLevel()->Int{return mLevel}
    func getStatus()->Status{return mStatus}
    func getCurrentHp()->Int{return mCurrentHp}
    func getExperience()->Int{return 65}
    func getNextExperience()->Int{return 100}
    func getSettedSkills()->[String]{return mSettedSkills}
    func getMasteredSkills()->[String]{return mMasteredSkills}
    func getItem()->(ItemData?,Int){return (mItem,mItemNum)}
    func getAccessory()->AccessoryData?{return mAccessory}
}
