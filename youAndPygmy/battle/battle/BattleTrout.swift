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
    private let mCover:SCNNode
    private let mChip:BattleChipData
    private let mPosition:BattlePosition!//座標
    private var mAttribute:TroutAttribute//地形属性
    private var mRidingChara:BattleChara?//このマスにいるキャラ
    init(aChip:BattleChipData,aPosition:BattlePosition){
        mNode=TroutMaker.createTrout(aShape:"box",aDirection:"")
        mChip=aChip
        //地形設定
        mNode.changeTerrain(aTerrain:aChip.terrain)
        mAttribute=aChip.attribute
        //座標設定
        mPosition=aPosition
        mNode.setPosition(aPosition:mPosition)
        //変色のためのカバーノード
        let tGeometory=SCNBox(width:gTroutSizeCG+0.001,height:gTroutSizeCG+0.001,length:gTroutSizeCG+0.001,chamferRadius:0)
        let tMaterial=SCNMaterial()
        tMaterial.diffuse.contents=UIColor(red:0,green:0,blue:0,alpha:0)
        tGeometory.materials=[tMaterial]
        mCover=SCNNode(geometry:tGeometory)
        mNode.addChildNode(mCover)
        //タップ時の関数
        mCover.setElement("tapFunction",{()->()in TroutTapMonitor.tappedTrout(aTrout:self)})
    }
    //ノード取得
    func getNode()->SCNNode{return mNode}
    func getPosition()->BattlePosition{return mPosition}
    func getAttribute()->TroutAttribute{return mAttribute}
    func getTerrain()->String{return mChip.name}
    func getTroutImageName()->String{return mChip.terrain}
    //このマスにいるキャラ
    func getRidingChara()->BattleChara?{return mRidingChara}
    func ride(aChara:BattleChara){
        if(mRidingChara != nil){print("マスに複数のキャラが乗った",mRidingChara!,aChara)}
        mRidingChara=aChara
    }
    func out(){mRidingChara=nil}
    //マスを変色する
    func changeColor(aColor:UIColor){
        mCover.geometry!.materials[0].diffuse.contents=aColor
    }
    //ノード追加
    func addNode(aNode:SCNNode){
        mNode.addChildNode(aNode)
    }
}
