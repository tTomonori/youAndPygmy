//
//  BarMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/02.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class BarMaker{
    private static var mTextures:Dictionary<String,SKTexture>=[:]//一度読み込んだ画像を保持
    static func setBarImage(aNode:SKNode,aBarName:String){
        var tMakedNode=aNode.childNode(withName:"maked")
        //変更用のノード作成
        if(tMakedNode==nil){
            tMakedNode=SKSpriteNode()
            tMakedNode!.name="maked"
            for tNode in aNode.children{
                let tNewNode=SKSpriteNode()
                tNewNode.position=tNode.position
                tNewNode.size=(tNode as! SKSpriteNode).size
                //バーの画像番号
                let tName=(tNode as! SKSpriteNode).texture!.description.components(separatedBy:"'")[1]
                let tImageNum=tName.substring(from: tName.index(before: tName.endIndex))
                tNewNode.setElement("barNum",tImageNum)
                tNode.alpha=0
                tMakedNode!.addChild(tNewNode)
            }
            aNode.addChild(tMakedNode!)
        }
        //画像変更
        for tNode in tMakedNode!.children{
            let tImageNum=tNode.getAccessibilityElement("barNum") as! String
            if let tTexture=mTextures[aBarName+tImageNum]{
                (tNode as! SKSpriteNode).texture=tTexture
            }
            else{
                let tTexture=SKTexture(imageNamed:aBarName+tImageNum)
                mTextures[aBarName+tImageNum]=tTexture
               (tNode as! SKSpriteNode).texture=tTexture
            }
        }
    }
    static func getBackgroundName(aNode:SKNode)->String{
        //バーの画像名
        var tBarName:String=""
        var tUperFlag=false
        for tChar in(aNode.childNode(withName:"background")!.children[0] as! SKSpriteNode)
            .texture!.description.components(separatedBy:"'")[1].characters{
                if(tUperFlag){tBarName+=String(tChar);continue}
                if(String(tChar)==String(tChar).uppercased()){
                    tUperFlag=true
                    tBarName+=String(tChar)
                }
        }
        tBarName=tBarName.substring(to:tBarName.index(tBarName.endIndex,offsetBy:-1))
        return tBarName
    }
    //バーの暗転,明転
    static func blendBar(aNode:SKNode,aColor:UIColor,aBlend:CGFloat){
        for tNode in aNode.children{
            (tNode as! SKSpriteNode).color=aColor
            (tNode as! SKSpriteNode).colorBlendFactor=aBlend
        }
    }
}
