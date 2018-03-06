//
//  Trout.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/17.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class TroutNode:SCNNode{
    //地形(テクスチャ)変更
    func changeTerrain(aTerrain:String){
        switch aTerrain {
        case "grass":
            let tMaterial = SCNMaterial()
            tMaterial.diffuse.contents = UIImage(named: "grass")
            self.geometry!.materials=[tMaterial]
        case "water":
            let tMaterial = SCNMaterial()
            tMaterial.diffuse.contents = UIImage(named: "water")
            self.geometry!.materials=[tMaterial]
        default:print("不正な地形名になってるよ→",aTerrain);break
        }
    }
    //物体設置
    func addObject(aObjectName:String){
        let tObject=ObjectMaker.make(aObjectName:aObjectName)
        tObject.position=SCNVector3(0,gTroutSizeCG/2,gTroutSizeCG/10)
        self.addChildNode(tObject)
    }
    //座標設定
    func setPosition(aPosition:FeildPosition){
        self.position=SCNVector3(x:gTroutSize*aPosition.x,y:gTroutSize*aPosition.y,z:gTroutSize*aPosition.z)
    }
    func setPosition(aPosition:BattlePosition){
        self.position=SCNVector3(x:gTroutSize*aPosition.x,y:gTroutSize*0,z:gTroutSize*aPosition.y)
    }
}
