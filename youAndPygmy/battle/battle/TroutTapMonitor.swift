//
//  TroutTapMonitor.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class TroutTapMonitor{
    static var mTappedTrout:BattleTrout?//最後にタップしたマス
    static let mSelectedMarker:SCNNode=createMarker()//最後にタップされたマスをマーク
    //マスがタップされた時
    static func tappedTrout(aTrout:BattleTrout){
        mTappedTrout=aTrout
        //タップされたマスを可視化
        aTrout.addNode(aNode:mSelectedMarker)
        //タップされたマスの情報を表示
        BattleDataUi.setTroutData(aTrout:aTrout)
    }
    //選択されたマスを返す
    static func getSelectedTrout()->BattleTrout?{return mTappedTrout}
    //タップされたマスを示すノードを生成
    static func createMarker()->SCNNode{
        let tRadius=gTroutSizeCG/2*1.4
        let tGeometory=SCNTube(innerRadius:tRadius*0.95,outerRadius:tRadius,height:tRadius*0.05)
        tGeometory.radialSegmentCount=4
        let tMaterial=SCNMaterial()
        tMaterial.diffuse.contents=UIColor(red:1,green:0,blue:0,alpha:1)
        tGeometory.materials=[tMaterial]
        let tMarker=SCNNode()
        let tBottom:Float=0.3
        let tTop:Float=0.8
        let tTime:Float=2.0
        for i in 0...2{
            let tNode=SCNNode(geometry:tGeometory)
            let tStartPosition=tBottom+0.15*i
            tNode.position=SCNVector3(0,tStartPosition*gTroutSize,0)
            tNode.rotation=SCNVector4(0,1,0,0.25*Float.pi)
            let tToTopTime=(tTop-tStartPosition)/(tTop-tBottom)*tTime
            tNode.runAction(SCNAction.repeatForever(SCNAction.sequence([
                SCNAction.move(to:SCNVector3(0,tTop*gTroutSize,0), duration: TimeInterval(tToTopTime)),
                SCNAction.run({(_)->()in tNode.position=SCNVector3(0,tBottom*gTroutSize,0)}),
                SCNAction.move(to:SCNVector3(0,tStartPosition*gTroutSize,0), duration: TimeInterval(tTime-tToTopTime)),
                ])))
            tMarker.addChildNode(tNode)
        }
        return tMarker
    }
}
