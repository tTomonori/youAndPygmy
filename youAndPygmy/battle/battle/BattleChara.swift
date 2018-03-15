//
//  BattleChara.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class BattleChara{
    private let mNode:CharaNode
    private let mTeam:Team
    private var mCurrentHp:Int
    private var mCurrentMp:Int
    private var mItem:String
    private var mItemNum:Int
    private let mInitialData:BattleCharaData
    private var mPosition:BattlePosition//このキャラがいる座標
    init(aData:BattleCharaData,aPosition:BattlePosition,aTeam:Team){
        mNode=CharaNode.init(aData:aData.image)
        mNode.setPosition(aPosition:aPosition)
        mNode.eulerAngles=SCNVector3(0,gRotationY,0)
        mTeam=aTeam
        mCurrentHp=aData.currentHp
        mCurrentMp=aData.status.mp
        mItem=aData.item
        mItemNum=aData.itemNum
        mInitialData=aData
        mPosition=aPosition
        Battle.getTrout(mPosition)!.ride(aChara:self)
    }
    func getNode()->SCNNode{return mNode}
    func getPosition()->BattlePosition{return mPosition}
    func getStatus(aStatus:String)->Int{
        return mInitialData.status.get(key:aStatus)
    }
    func getMobility()->Mobility{return mInitialData.mobility}
    func getAi()->AiType{return mInitialData.ai}
    func getImage()->CharaImageData{return mInitialData.image}
    func getLevel()->Int{return mInitialData.level}
    func getName()->String{return mInitialData.name}
    func getCurrentHp()->Int{return mCurrentHp}
    func getMaxHp()->Int{return mInitialData.status.hp}
    func getCurrentMp()->Int{return mCurrentMp}
    func getMaxMp()->Int{return mInitialData.status.mp}
    func getItem()->(String,Int){return (mItem,mItemNum)}
    func getSkill()->[String]{return mInitialData.skill}
    func getTeam()->Team{return mTeam}
    //指定したスキルが使用できるか
    func canUse(aSkill:String)->Bool{
        return mCurrentMp>=SkillDictionary.get(aSkill).mp
    }
    //指定した座標へ瞬間移動
    func move(aPosition:BattlePosition){
        Battle.getTrout(mPosition)!.out()
        let tTrout=Battle.getTrout(aPosition)!
        mNode.setPosition(aPosition:aPosition)
        tTrout.ride(aChara:self)
        mPosition=aPosition
    }
    //ルートに沿って移動
    func move(aRoute:[BattlePosition],aEndFunction:@escaping ()->()){
        if(aRoute.count==0){aEndFunction();return}
        //マスから移動
        Battle.getTrout(mPosition)!.out()
        //移動アニメーション作成
        var tAnimation:[SCNAction]=[]
        var tPrePosition=mPosition
        for tPosition in aRoute{
            let tXDif=tPosition.x-tPrePosition.x
            let tYDif=tPosition.y-tPrePosition.y
            tAnimation.append(SCNAction.move(
                by: SCNVector3(tXDif*gTroutSizeCG,0,tYDif*gTroutSizeCG),
                duration:0.25)
            )
            tPrePosition=tPosition
        }
        tAnimation.append(SCNAction.run({ (_) in
            //移動終了時の関数
            self.mPosition=aRoute.last!
            //マスに乗る
            Battle.getTrout(self.mPosition)?.ride(aChara:self)
            aEndFunction()
        }))
        mNode.runAction(SCNAction.sequence(tAnimation))
    }
    //戦闘不能か
    func isDown()->Bool{
        return (mCurrentHp<=0) ?true:false
    }
    //戦闘不能アニメ
    func down(aEndFunction:@escaping ()->()){
        let tTrout=Battle.getTrout(mPosition)!
        tTrout.out()
        mNode.changePattern(aPattern:"damage")
        mNode.animateDown(aEndFunction:{()->()in
            self.mNode.removeFromParentNode()
            aEndFunction()
        })
    }
    //スキルを使用してmp消費
    func useMp(aMp:Int){
        mCurrentMp-=aMp
    }
    //指定した座標に反撃する反撃スキル取得
    func getCounterSkill(aPosition:BattlePosition)->String?{
        for tSkill in getSkill(){
            if(tSkill==""){continue}
            let tSkillData=SkillDictionary.get(tSkill)
            if(!tSkillData.counter){continue}//反撃不可スキル
            if(!canUse(aSkill:tSkill)){continue}//スキルが使えない
            //スキルの攻撃範囲取得
            let tRange=SkillRangeSearcher.searchRange(aPosition:getPosition(),aSkill:tSkill)
            let tDefenderTrout=Battle.getTrout(aPosition)!
            //攻撃範囲内に反撃する相手がいるかどうか
            for tTrout in tRange{
                if(tDefenderTrout !== tTrout){continue}
                //反撃できる
                return tSkill
            }
            continue
        }
        return nil
    }
    //ダメージを受ける
    func addDamage(aDamage:Int,aEndFunction:@escaping ()->()){
        mCurrentHp-=aDamage
        if(mCurrentHp<0){mCurrentHp=0}
        //アニメーション
        mNode.animateDamage(aEndFunction:aEndFunction)
        mNode.displayLabel(aText:String(aDamage),aColor:UIColor(red:1,green:0.5,blue:0,alpha:1))
    }
    //回復する
    func heal(aHeal:Int,aEndFunction:@escaping ()->()){
        mCurrentHp+=aHeal
        if(mInitialData.status.hp<mCurrentHp){mCurrentHp=mInitialData.status.hp}
        //アニメーション
        mNode.displayLabel(aText:String(aHeal),aColor:UIColor(red:0,green:1,blue:0,alpha:1),aEndFunction:{
            aEndFunction()
        })
    }
    //スキルを避けた
    func displayAvoided(aEndFunction:@escaping ()->()){
        mNode.displayLabel(aText:"Miss",aColor:UIColor(red:0.5,green:0.5,blue:0.5,alpha:1),aEndFunction:{
            aEndFunction()
        })
    }
    //反撃する
    func displayCounter(aEndFunction:@escaping ()->()){
        mNode.displayLabel(aText:"反撃",aColor:UIColor(red:0,green:0,blue:1,alpha:1),aEndFunction:{
            aEndFunction()
        })
    }
    //アイテムを使用した
    func useItem(){
        mItemNum-=1
        if(mItemNum==0){
            //アイテムがなくなった
            mItem=""
        }
    }
    //ジャンプ
    func junp(aEndFunction:@escaping ()->()){
        mNode.junp {
            aEndFunction()
        }
    }
}

enum Team{
    case you
    case enemy
}
