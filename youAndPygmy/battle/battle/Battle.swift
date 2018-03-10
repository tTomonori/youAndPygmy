//
//  Battle.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/04.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class Battle{
    private static var mScene:SCNScene!
    private static var mTrouts:[[BattleTrout]]!
    private static var mCameraNode:SCNNode!//カメラ
    private static var mAllies:[BattleChara]!//味方
    private static var mEnemies:[BattleChara]!//敵
    private static var mEndFunction:((String)->())!//戦闘終了時に呼ぶ関数
    //戦闘情報をセット
    static func setBattle(aBattleData:BattleData){
        mScene=SCNScene()
        mTrouts=[]
        mAllies=[]
        mEnemies=[]
        //マス設定
        for tY in 0..<aBattleData.feild.feild.count{
            let tLine=aBattleData.feild.feild[tY]
            var tMasList:[BattleTrout]=[]
            for tX in 0..<tLine.count{
                let tChipNum=tLine[tX]
                let tChipData=aBattleData.feild.chip[tChipNum]!
                let tTrout=BattleTrout(aChip:tChipData,aPosition:BattlePosition(x:tX,y:tY))
                mScene.rootNode.addChildNode(tTrout.getNode())
                tMasList.append(tTrout)
            }
            mTrouts.append(tMasList)
        }
        //味方配置
        for i in 0..<aBattleData.allies.count{
            let tBattleData=aBattleData.allies[i]
            if(tBattleData==nil){continue}
            let tPosition=aBattleData.allyPosition[i]
            let tChara=BattleChara(aData:tBattleData!,aPosition:tPosition,aTeam:.you)
            mScene.rootNode.addChildNode(tChara.getNode())
            mAllies.append(tChara)
        }
        //敵配置
        for i in 0..<aBattleData.enemies.count{
            let tBattleData=aBattleData.enemies[i]
            if(tBattleData==nil){continue}
            let tPosition=aBattleData.enemyPosition[i]
            let tChara=BattleChara(aData:tBattleData!,aPosition:tPosition,aTeam:.enemy)
            mScene.rootNode.addChildNode(tChara.getNode())
            mEnemies.append(tChara)
        }
        //カメラ配置
        mCameraNode=SCNNode()
        mCameraNode.camera=SCNCamera()
        mCameraNode.rotation=SCNVector4(-1,-0.5*Float.pi,0,0.2*Float.pi)
        mCameraNode.position=SCNVector3(x:gTroutSize*(-2),y:gTroutSize*2.7,z:gTroutSize*(aBattleData.feild.feild.count+2))
        mScene.rootNode.addChildNode(mCameraNode)
        
        Turn.setCharas(aCharas:mAllies+mEnemies)
    }
    //戦闘開始
    static func start(aEndFunction:@escaping (String)->()){
        mEndFunction=aEndFunction
        BattleUiScene.initScene()
        BattleUiScene.display()
        Turn.start()
    }
    //シーン表示
    static func display(){
        gGameViewController.set3dScene(aScene:mScene)
    }
    //マス取得
    static func getTrout(aPosition:BattlePosition)->BattleTrout?{
        if(aPosition.x<0){return nil}
        if(aPosition.y<0){return nil}
        if(aPosition.y>=mTrouts.count){return nil}
        if(aPosition.x>=mTrouts[aPosition.y].count){return nil}
        return mTrouts[aPosition.y][aPosition.x]
    }
}
