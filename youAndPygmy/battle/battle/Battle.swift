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

let gRotationY = -0.1*Float.pi
class Battle{
    private static var mBattleData:BattleData!
    private static var mScene:SCNScene!
    private static var mTrouts:[[BattleTrout]]!
    private static var mCameraNode:SCNNode!//カメラ
    private static var mEndFunction:((String)->())!//戦闘終了時に呼ぶ関数
    //戦闘情報をセット
    static func setBattle(aBattleData:BattleData){
        mBattleData=aBattleData
        mScene=SCNScene()
        mTrouts=[]
        var tAllies:[BattleChara]=[]
        var tEnemies:[BattleChara]=[]
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
            tAllies.append(tChara)
        }
        //敵配置
        for i in 0..<aBattleData.enemies.count{
            let tBattleData=aBattleData.enemies[i]
            if(tBattleData==nil){continue}
            let tPosition=aBattleData.enemyPosition[i]
            let tChara=BattleChara(aData:tBattleData!,aPosition:tPosition,aTeam:.enemy)
            mScene.rootNode.addChildNode(tChara.getNode())
            tEnemies.append(tChara)
        }
        //カメラ配置
        mCameraNode=SCNNode()
        mCameraNode.camera=SCNCamera()
        mCameraNode.eulerAngles=SCNVector3(-0.1*Float.pi,gRotationY,0)
        mCameraNode.position=SCNVector3(x:gTroutSize*(-1),y:gTroutSize*2.7,z:gTroutSize*(2.5+aBattleData.feild.feild.count))
        mScene.rootNode.addChildNode(mCameraNode)
        
        CharaManager.set(aAllies:tAllies,aEnemies:tEnemies)
    }
    //戦闘開始
    static func start(aEndFunction:@escaping (String)->()){
        mEndFunction=aEndFunction
        BattleUiScene.initScene()
        BattleUiScene.display()
        Turn.start()
    }
    //戦闘終了
    static func end(aResult:String){
        mEndFunction(aResult)
    }
    //勝敗判定
    static func judgeBattle()->String?{
        //敗北判定
        switch mBattleData.loseCondition {
        case "extinction"://全滅
            if(!CharaManager.exist(aTeam:.you)){
                return "lose"
            }
        default:break
        }
        //勝利判定
        switch mBattleData.winCondition {
        case "extinction"://全滅
            if(!CharaManager.exist(aTeam:.enemy)){
                return "win"
            }
        default:break
        }
        return nil
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
