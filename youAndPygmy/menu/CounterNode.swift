//
//  CounterNode.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/04/02.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class CounterNode{
    private static let mCounterNode=createCounter()
    private static let mNumberLabel=mCounterNode.childNode(withName:"counter")!.childNode(withName:"number") as! SKLabelNode
    private static var mMax:Int!
    private static var mMin:Int!
    private static var mNumber:Int!
    private static func createCounter()->SKNode{
        let tScene=SKScene(fileNamed:"counterNode")!
        let tCounterNode=tScene.childNode(withName:"counterNode")!
        //ボタンタップイベント
        tCounterNode.childNode(withName:"plusButton")!.setElement("tapFunction",{()->()in
            self.plus()
        })
        tCounterNode.childNode(withName:"minusButton")!.setElement("tapFunction",{()->()in
            self.minus()
        })
        tCounterNode.removeFromParent()
        return tCounterNode
    }
    static func show(aNode:SKNode,aMin:Int,aMax:Int,aInitialNumber:Int){
        mMax=aMax
        mMin=aMin
        mNumber=aInitialNumber
        mNumberLabel.text=String(mNumber)
        aNode.addChild(mCounterNode)
    }
    static func hide(){
        mCounterNode.removeFromParent()
    }
    //カウンタ+1
    static func plus(){
        mNumber=mNumber+1
        if(mNumber>mMax){mNumber=mMax}
        mNumberLabel.text=String(mNumber)
    }
    //カウンタ-1
    static func minus(){
        mNumber=mNumber-1
        if(mNumber<mMin){mNumber=mMin}
        mNumberLabel.text=String(mNumber)
    }
    //カウンタの数字変更
    static func setNumber(aNum:Int){
        mNumber=aNum
        mNumberLabel.text=String(mNumber)
    }
    //選択している数字取得
    static func getNumber()->Int{
        return mNumber
    }
}
