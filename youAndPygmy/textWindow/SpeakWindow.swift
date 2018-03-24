//
//  SpeakWindow.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/22.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class SpeakWindow{
    private static var mScene:SKScene!
    private static var mEndFunction:()->()={()->()in}
    static func display(aSentence:String,aEndFunction:@escaping ()->()){
        mEndFunction=aEndFunction
        mScene=SKScene(fileNamed:"speakWindow")
        //タップ時関数セット
        for tNode in mScene.children{
            if(tNode.name==nil){continue}
            switch tNode.name! {
            case "speakWindow":
                tNode.setElement("tapFunction",{()->Void in self.tapWindow()})
            case "text":
                (tNode as! SKLabelNode).text=aSentence
            default:break
            }
        }
        gGameViewController.set2dScene(aScene:mScene)
        gGameViewController.allowUserOperate()
    }
    //テキストウィンドウがタップされた
    static func tapWindow(){
        gGameViewController.denyUserOperate()
        close()
        mEndFunction()
    }
    //閉じる
    static func close(){
        gGameViewController.set2dScene(aScene:gEmptySprite)
    }
}
