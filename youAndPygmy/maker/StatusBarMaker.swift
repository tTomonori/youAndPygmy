//
//  StatusBarMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/25.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class StatusBarMaker{
    //ゲージ調整
    static func setGage(aNode:SKSpriteNode,aCurrent:Int,aMax:Int){
        //実数値
        let tValue=aNode.childNode(withName:"value") as! SKLabelNode
        tValue.text=String(aCurrent)+" / "+String(aMax)
        //ゲージ
        let tBarBox=aNode.childNode(withName:"barBox") as! SKSpriteNode
        let tBar=tBarBox.childNode(withName:"bar") as! SKSpriteNode
        tBar.size=CGSize(
            width:CGFloat(Int(aNode.size.width)*aCurrent/aMax),
            height:tBarBox.size.height
        )
    }
}
