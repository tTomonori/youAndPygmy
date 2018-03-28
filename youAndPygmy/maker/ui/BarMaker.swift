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
    static func setBarImage(aNode:SKNode,aBarName:String){
        for tNode in aNode.children{
            //テクスチャに使用している画像名
            let tName=(tNode as! SKSpriteNode).texture!.description.components(separatedBy:"'")[1]
            
            let tImageNum=tName.substring(from: tName.index(before: tName.endIndex))
            (tNode as! SKSpriteNode).texture=SKTexture(imageNamed:aBarName+tImageNum)
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
}
