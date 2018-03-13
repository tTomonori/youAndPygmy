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
        mTeam=aTeam
        mCurrentHp=aData.currentHp
        mCurrentMp=aData.status.mp
        mItem=aData.item
        mItemNum=aData.itemNum
        mInitialData=aData
        mPosition=aPosition
        Battle.getTrout(aPosition:mPosition)!.ride(aChara:self)
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
    //指定した座標へ瞬間移動
    func move(aPosition:BattlePosition){
        Battle.getTrout(aPosition:mPosition)!.out()
        let tTrout=Battle.getTrout(aPosition:aPosition)!
        mNode.setPosition(aPosition:aPosition)
        tTrout.ride(aChara:self)
        mPosition=aPosition
    }
    //ルートに沿って移動
    func move(aRoute:[BattlePosition],aEndFunction:@escaping ()->()){
        //マスから移動
        Battle.getTrout(aPosition:mPosition)!.out()
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
            Battle.getTrout(aPosition:self.mPosition)?.ride(aChara:self)
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
        let tTrout=Battle.getTrout(aPosition:mPosition)!
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
    //ダメージを受ける
    func addDamage(aDamage:Int,aEndFunction:@escaping ()->()){
        mCurrentHp-=aDamage
        if(mCurrentHp<0){mCurrentHp=0}
        //アニメーション
        mNode.animateDamage(aEndFunction:aEndFunction)
    }
    //回復する
    func heal(aHeal:Int,aEndFunction:@escaping ()->()){
        mCurrentHp+=aHeal
        if(mInitialData.status.hp<mCurrentHp){mCurrentHp=mInitialData.status.hp}
        //アニメーション
        aEndFunction()
    }
    //アイテムを使用した
    func useItem(){
        mItemNum-=1
        if(mItemNum==0){
            //アイテムがなくなった
            mItem=""
        }
    }
}

enum Team{
    case you
    case enemy
}
