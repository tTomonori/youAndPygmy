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
    private var mSetSkills:[String]//セットしたスキル
    private var mMasteredSkills:[String]//習得しているスキル
    private var mItem:String//持ち物
    private var mItemNum:Int//持ち物の数
    private var mAccessory:String//アクセサリ
    init(aData:AccompanyingData){
        mName=aData.name
        mRaceData=PygmyDictionary.get(aRace:aData.raceName)
        mPersonal=aData.personal
        mLevel=aData.level
        mStatus=StatusCalcurator.calcurate(aRaceStatus:mRaceData.raceStatus,aLevel:mLevel,aPersonality:mPersonal)
        mCurrentHp=aData.currentHp
        mSetSkills=aData.setSkills
        mMasteredSkills=aData.masteredSkills
        mItem=aData.item
        mItemNum=aData.itemNum
        mAccessory=aData.accessory
    }
    //名前取得
    func getName()->String{return mName}
    //種族データ取得
    func getRaceData()->RaceData{return mRaceData}
    func getLevel()->Int{return mLevel}
    func getStatus()->Status{return mStatus}
    func getCurrentHp()->Int{return mCurrentHp}
    func getExperience()->Int{return 65}
    func getNextExperience()->Int{return 100}
}
