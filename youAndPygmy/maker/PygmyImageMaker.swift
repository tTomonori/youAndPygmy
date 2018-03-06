//
//  PygmyImageMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/27.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmyImageMaker{
    //画像セット
    static func setImage(aNode:SKSpriteNode,aPygmy:Pygmy){
        if(aNode.children.count>0){
            (aNode.childNode(withName:"body") as! SKSpriteNode).texture
                = SKTexture(imageNamed:aPygmy.getRaceData().raceKey+"_body")
            (aNode.childNode(withName:"eye") as! SKSpriteNode).texture
                = SKTexture(imageNamed:aPygmy.getRaceData().raceKey+"_eye")
            (aNode.childNode(withName:"mouth") as! SKSpriteNode).texture
                = SKTexture(imageNamed:aPygmy.getRaceData().raceKey+"_mouth")
        }
        else{
            //ノードが用意されていない
            aNode.color=UIColor(red:0,green:0,blue:0,alpha:0)
            for tParts in ["body","eye","mouth"]{
                let tNode=SKSpriteNode()
                tNode.size=aNode.size
                tNode.texture=SKTexture(imageNamed:aPygmy.getRaceData().raceKey+"_"+tParts)
                tNode.name=tParts
                aNode.addChild(tNode)
            }
        }
    }
}
