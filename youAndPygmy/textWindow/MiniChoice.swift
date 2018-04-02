//
//  MiniChoice.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class MiniChoice{
    private static let mMaxSelectNum=4
    private static let mScreen=createScreen()
    private static let mChoice=getChoiceList()
    private static var mSelectedFunction:((String)->())!
    private static var mChoiceText:[String]!
    private static let mTextWindow=mScreen.childNode(withName:"textWindow")!
    private static let mText=mTextWindow.childNode(withName:"text") as! SKLabelNode
    //選択肢表示
    static func select(aChoice:[String],aFunction:@escaping (String)->()){
        mChoiceText=aChoice
        mSelectedFunction=aFunction
        let tChoiceNum=aChoice.count
        for i in 0..<mMaxSelectNum{
            if(i<tChoiceNum){
                let tChoice=mChoice[i]
                tChoice.alpha=1
                (tChoice.childNode(withName:"label") as! SKLabelNode).text=aChoice[i]
            }
            else{
                mChoice[i].alpha=0
            }
        }
        gGameViewController.addOverlayNode(aNode:mScreen)
    }
    //テキストとともに選択肢表示
    static func selectWithText(aChoice:[String],aText:String,aFunction:@escaping (String)->()){
        mText.text=aText
        mTextWindow.alpha=1
        select(aChoice:aChoice,aFunction:aFunction)
    }
    //選択された
    static func selected(_ num:Int){
        mScreen.removeFromParent()
        mTextWindow.alpha=0
        mSelectedFunction(mChoiceText[num])
    }
    //表示するノード生成
    private static func createScreen()->SKNode{
        let tScene=SKScene(fileNamed:"miniChoice")!
        let tScreen=tScene.childNode(withName:"screen")!
        tScreen.childNode(withName:"textWindow")!.alpha=0
        tScreen.removeFromParent()
        tScreen.setElement("tapEventType","block")
        return tScreen
    }
    private static func getChoiceList()->[SKNode]{
        let tChoice=mScreen.childNode(withName:"selector")!
        var tNodes:[SKNode]=[]
        for i in 0..<mMaxSelectNum{
            let tBar=tChoice.childNode(withName:"choice"+String(i))!
            //タップ関数
            tBar.setElement("tapFunction",{()->()in
                self.selected(i)
            })
            tNodes.append(tBar)
        }
        return tNodes
    }
}
