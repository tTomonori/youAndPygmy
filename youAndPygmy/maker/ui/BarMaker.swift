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
    static func setBarImage(aNode:SKSpriteNode,aBarName:String){
        for tNode in aNode.children{
            //テクスチャに使用している画像名
            let tName=(tNode as! SKSpriteNode).texture!.description.components(separatedBy:"'")[1]
            
            let tImageNum=tName.substring(from: tName.index(before: tName.endIndex))
            (tNode as! SKSpriteNode).texture=SKTexture(imageNamed:aBarName+tImageNum)
        }
    }
}
