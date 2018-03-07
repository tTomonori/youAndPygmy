//
//  PygmyObject.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class CharaNode:SCNNode{
    static let mParts=["body","eye","mouth"]
    var mParts:Dictionary<String,PanelNode>//部位ごとの画像のノード
    init(aData:CharaImageData){
        mParts=[:]
        super.init()
        //部位ごとに画像ノード生成
        for i in 0..<CharaNode.mParts.count{
            let tParts=CharaNode.mParts[i]
            let tNode=PanelNode(aWidth:gTroutSizeCG,aHeight:gTroutSizeCG*1.5)
            if let tDictionary=aData.getDictionary(parts:tParts){
                tNode.setImage(aImages:tDictionary)
                tNode.changeImage(aKey:"normal")
            }
            else{tNode.toPenetrate()}
            tNode.position=SCNVector3(x:0,y:0,z:0.001*i)
            self.addChildNode(tNode)
            mParts[tParts]=tNode
        }
        //アクセサリのノード生成
        let tNode=PanelNode(aWidth:gTroutSizeCG,aHeight:gTroutSizeCG*1.5)
        if let tImageName=aData.getAccessory(){
            tNode.setImage(aImage:tImageName)
        }
        else{tNode.toPenetrate()}
        tNode.position=SCNVector3(x:0,y:0,z:0.001*CharaNode.mParts.count)
        self.addChildNode(tNode)
        mParts["accessory"]=tNode
    }
    //SCNNodeを継承し、イニシャライザを実装するなら必要(らしい?)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //座標設定
    func setPosition(aPosition:BattlePosition){
        self.position=aPosition.convertVector()
    }
}
