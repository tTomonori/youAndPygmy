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
    private var mSettedSkills:[String?]//セットしたスキル
    private var mMasteredSkills:[String?]//習得しているスキル
    private var mItem:String?//持ち物
    private var mItemNum:Int//持ち物の数
    private var mAccessory:String?//アクセサリ
    init(aData:AccompanyingData){
        mName=aData.name
        mRaceData=PygmyDictionary.get(aData.raceName)
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
    func getItem()->(String?,Int){return (mItem,mItemNum)}
    func getAccessory()->String?{return mAccessory}
    func getImage()->CharaImageData{
        if(mAccessory != nil){//アクセサリあり
            return CharaImageData.init(base:mRaceData.image,accessory:AccessoryDictionary.get(mAccessory!).image)
        }
        return CharaImageData.init(base:mRaceData.image,accessory:nil)
    }
    //装備スキル取得
    func getSettedSkills()->[String?]{return mSettedSkills}
    ////////////////////////////////////////////////////////////////
    //戦闘
    //戦闘で使えるスキル取得
    func getBattleSkills()->[String]{
        var tSkills:[String]=[]
        //装備スキル
        for tSkill in mSettedSkills{
            if(tSkill==nil){continue}
            tSkills.append(tSkill!)
        }
        //アクセサリスキル
        if let tAccessory=getAccessory(){
            if let tSkill=AccessoryDictionary.get(tAccessory).skill{
                tSkills.append(tSkill)
            }
        }
        return tSkills
    }
    //ステータスの補正値を返す
    func getCorrection()->Status{
        var tStatus=gZeroStatus
        if let tAccessory=getAccessory(){
            tStatus=tStatus+AccessoryDictionary.get(tAccessory).status
        }
        return tStatus
    }
    //補正値込みのステータスを返す
    func getCorrectedStatus()->Status{
        return mStatus+getCorrection()
    }
    //補正値込みの移動力を返す
    func getCorrectedMobility()->Mobility{
        return mRaceData.mobility
    }
    ///////////////////////////////////////////////////////
    //スキル
    //スキルセット
    func setSkill(aSetPosition:Int,aSetSkillNum:Int){
        if(mMasteredSkills[aSetSkillNum]==nil){return}
        mSettedSkills=SettedSkillArranger.rearrenge(aList:mSettedSkills,
                                                    aInsertSkill:mMasteredSkills[aSetSkillNum]!,aInsertIndex:aSetPosition)
    }
    //スキルを外す
    func removeSettedSkill(_ i:Int){
        if(mSettedSkills[i]==nil){return}
        mSettedSkills=SettedSkillArranger.rearrenge(aList:mSettedSkills,removeNum:i)
    }
    //スキル並び替え
    func rearrangeSettedSkill(_ i:Int,_ j:Int){
        if(mSettedSkills[i]==nil || mSettedSkills[j]==nil){return}
        mSettedSkills=SettedSkillArranger.rearrenge(aList:mSettedSkills,
                                                    aInsertSkill:mSettedSkills[i]!,aInsertIndex:j)
    }
    func rearrangeMasteredSkill(_ i:Int,_ j:Int){
        if(mMasteredSkills[i]==nil || mMasteredSkills[j]==nil){return}
        let tSkill=mMasteredSkills.remove(at:i)
        mMasteredSkills.insert(tSkill,at:j)
    }
    ///////////////////////////////////////////////////////
    //アイテム
    //回復
    func heal(aHeal:Int){
        mCurrentHp+=aHeal
        if(mCurrentHp>mStatus.hp){mCurrentHp=mStatus.hp}
    }
}
