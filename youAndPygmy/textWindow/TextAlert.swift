//
//  TextAlert.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/31.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class TextAlert{
    private static let mWindow=createWindow()
    private static let mText:SKLabelNode=mWindow.childNode(withName:"text")! as! SKLabelNode
    private static func createWindow()->SKNode{
        let tScene=SKScene(fileNamed:"textAlert")!
        let tWindow=tScene.childNode(withName:"alertWindow")!
        tWindow.removeFromParent()
        return tWindow
    }
    static func alert(aText:String){
        //アクション削除
        mWindow.removeAllActions()
        //親から取り除かれたいなければremove
        if(mWindow.parent != nil){mWindow.removeFromParent()}
        
        mText.text=aText
        gGameViewController.addOverlayNode(aNode:mWindow)
        //アニメーション
        mWindow.run(SKAction.sequence([
            SKAction.fadeIn(withDuration:0),
            SKAction.wait(forDuration:0.8),
            SKAction.fadeOut(withDuration:0.6),
            SKAction.run({
                mWindow.removeFromParent()
            })
            ]))
    }
}
