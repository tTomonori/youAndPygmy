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
    //全部位の画像パターン変更
    func changePattern(aPattern:String){
        for (_,tPanel) in mParts{
            tPanel.changeImage(aKey:aPattern)
        }
    }
    //指定した部位の画像パターン変更
    func changeImage(aParts:String,aPattern:String){
        let tPanel=mParts[aParts]!
        tPanel.changeImage(aKey:aPattern)
    }
    //ダメージアニメーション
    func animateDamage(aEndFunction:@escaping ()->()){
        changePattern(aPattern:"damage")
        self.runAction(SCNAction.sequence([
            SCNAction.fadeOut(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeIn(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeOut(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeIn(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeOut(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeIn(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeOut(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeIn(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeOut(duration:0),
            SCNAction.wait(duration:0.1),
            SCNAction.fadeIn(duration:0),
            SCNAction.run({(_)->()in
                self.changePattern(aPattern:"normal")
                aEndFunction()
            })
            ]))
    }
    //戦闘不能アニメーション
    func animateDown(aEndFunction:@escaping ()->()){
        self.runAction(SCNAction.sequence([
            SCNAction.fadeOut(duration:0.4),
            SCNAction.run({(_)->()in aEndFunction()})
            ]))
    }
    //文字表示
    func displayLabel(aText:String,aColor:UIColor,aEndFunction:@escaping ()->()={()->()in}){
        let tText=SCNText(string:aText,extrusionDepth:gTroutSizeCG*0.1)
        tText.font=UIFont(name:"Helvetica Bold",size:0.3)
        tText.materials[0].diffuse.contents=aColor
        let tNode=SCNNode(geometry:tText)
        let (tMin,tMax)=tNode.boundingBox
        tNode.position=SCNVector3(-(tMax.x-tMin.x)/2,-gTroutSize,gTroutSize*0.1)
        self.addChildNode(tNode)
        tNode.runAction(SCNAction.sequence([
            SCNAction.move(by:SCNVector3(0,gTroutSize*0.5,0),duration:1),
            SCNAction.run({_ in
                tNode.removeFromParentNode()
                aEndFunction()
            })
            ]))
    }
}
