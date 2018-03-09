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
    private let mCurrentHp:Int
    private let mCurrentMp:Int
    private let mItem:String
    private let mItemNum:Int
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
}

enum Team{
    case you
    case enemy
}
