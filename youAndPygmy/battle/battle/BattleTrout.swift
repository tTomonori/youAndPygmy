//
//  BattleTrout.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class BattleTrout{
    private let mNode:TroutNode
    private let mPosition:BattlePosition!//座標
    private var mAttribute:String//地形属性
    init(aChip:BattleChipData,aPosition:BattlePosition){
        mNode=TroutMaker.createTrout(aShape:"box",aDirection:"")
        //地形設定
        mNode.changeTerrain(aTerrain:aChip.terrain)
        mAttribute=aChip.attribute
        //座標設定
        mPosition=aPosition
        mNode.setPosition(aPosition:mPosition)
    }
    //ノード取得
    func getNode()->SCNNode{return mNode}
}
