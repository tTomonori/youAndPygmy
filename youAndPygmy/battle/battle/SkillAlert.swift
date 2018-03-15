//
//  SkillAlert.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/15.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class SkillAlert{
    private static let mTextBox=BattleUiScene.getNode(aName:"skillAlert")!
    private static let mText=mTextBox.childNode(withName:"name") as! SKLabelNode
    //スキル名表示
    static func displaySkillName(aName:String){
        mTextBox.removeAllActions()
        mTextBox.alpha=0
        mText.text=aName
        mTextBox.position=CGPoint(x:250,y:140)
        mTextBox.run(SKAction.sequence([
            //フェードイン
            SKAction.group([
                SKAction.fadeIn(withDuration:0.2),
                SKAction.move(by:CGVector(dx:0,dy:20),duration:0.2)
                ]),
            //移動
            SKAction.move(by:CGVector(dx:0,dy:30), duration:1),
            //フェードアウト
            SKAction.group([
                SKAction.fadeOut(withDuration:0.2),
                SKAction.move(by:CGVector(dx:0,dy:20),duration:0.2)
                ])
            ]))
    }
}
