//
//  ChoiceDisplayer.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/15.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ChoiceDisplayer{
    //二択用ノード
    private static let mConfirmationScreen=createConfirmeNode()
    private static let mConfirmationTextWindow=mConfirmationScreen.childNode(withName:"textWindow")!
    //選択肢選択後に実行する関数
    private static var mAnserfunction:((Bool)->())!
    //二択
    static func confirme(aText:String,aAnser:@escaping (Bool)->()){
        mAnserfunction=aAnser
        (mConfirmationTextWindow.childNode(withName:"text") as! SKLabelNode).text=aText
        gGameViewController.addOverlayNode(aNode:mConfirmationScreen)
    }
    //二択から選択
    static func anser(aAnser:Bool){
        mConfirmationScreen.removeFromParent()
        mAnserfunction(aAnser)
    }
    //二択用ノード生成
    static func createConfirmeNode()->SKNode{
        let tScene=SKScene(fileNamed:"choiceDisplayer")!
        let tNode=tScene.childNode(withName:"screen")!
        tNode.removeFromParent()
        //タップイベント
        tNode.accessibilityElements=["block"]
        tNode.childNode(withName:"cancelNode")!.accessibilityElements=["run",{self.anser(aAnser:false)}]
        tNode.childNode(withName:"okNode")!.accessibilityElements=["run",{self.anser(aAnser:true)}]
        
        return tNode
    }
}
