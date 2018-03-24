//
//  DragNodeOperator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class DragNodeOperator{
    private static var mDraggingNode:SKNode!
    private static var mParentNode:SKNode!
    private static var mOriginalPoint:CGPoint!
    private static var mOriginalZPosition:CGFloat!
    //ノードにドラッグイベント追加
    static func setDragEvent(aNode:SKNode,
                              aStart:@escaping (CGPoint)->(),aDragging:@escaping (CGPoint)->(),aEnd:@escaping (CGPoint)->()){
        aNode.accessibilityElements!.append(["start":aStart,"dragging":aDragging,"end":aEnd])
    }
    //シーンにドラッグイベント追加
    static func setDragScene(aScene:SKScene){
        aScene.accessibilityElements=[{(aRecognizer)->()in
            self.drag(aRecognizer)
            }]
    }
    //ドラッグされた
    static func drag(_ aRecognizer: UIGestureRecognizer){
        let tPoint=gGameViewController.get2dPoint(aRecognizer)
        switch aRecognizer.state {
        case .began://パン開始
            for tNode in gGameViewController.get2dNodes(aPoint:tPoint){
                if(tNode.accessibilityElements==nil){continue}
                if(tNode.accessibilityElements!.count<3){continue}
                //ノードの情報保持
                mDraggingNode=tNode
                mParentNode=tNode.parent
                mOriginalPoint=mDraggingNode.position
                mOriginalZPosition=mDraggingNode.zPosition
                mDraggingNode.removeFromParent()
                gGameViewController.get2dScene().addChild(mDraggingNode)
                mDraggingNode.position=tPoint
                //ドラッグ開始関数
                let tEvents=tNode.accessibilityElements![2]
                ((tEvents as! Dictionary<String,(CGPoint)->()>)["start"]!)(tPoint)
                break
            }
        case .changed://パン入力
            if(mDraggingNode==nil){break}
            mDraggingNode.position=tPoint
        case .ended://パン終了
            if(mDraggingNode==nil){break}
            mDraggingNode.position=mOriginalPoint
            mDraggingNode.zPosition=mOriginalZPosition
            mDraggingNode.removeFromParent()
            mParentNode.addChild(mDraggingNode)
            mDraggingNode=nil
        default:
            return
        }
    }
}
