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
    private static var mDraggingNode:SKNode!//ドラッグしているノード
    private static var mParentNode:SKNode!//ドラッグしているノードの元の親
    private static var mOriginalPoint:CGPoint!//ドラッグしているノードの元の位置
    private static var mOriginalZPosition:CGFloat!//ドラッグしているノードの元のzIndex
    private static var mDragOverNode:SKNode?//最後にドラッグオーバーされたノード
    //ノードにドラッグイベント追加
    static func setDragEvent(aNode:SKNode,
                              aStart:@escaping (CGPoint)->(),aDragging:@escaping (CGPoint)->(),
                              aEnd:@escaping (CGPoint)->()){
        aNode.setElement("startDragFunction",aStart)
        aNode.setElement("draggingFunction",aDragging)
        aNode.setElement("endDragFunction",aEnd)
    }
    //シーンにドラッグイベント追加
    static func setDragScene(aScene:SKScene){
        aScene.setElement("dragFunction",{(aRecognizer)->()in
            self.drag(aRecognizer)
        })
    }
    //ドラッグされた
    static func drag(_ aRecognizer: UIGestureRecognizer){
        let tPoint=gGameViewController.get2dPoint(aRecognizer)
        switch aRecognizer.state {
        case .began://パン開始
            for tNode in gGameViewController.get2dNodes(aPoint:tPoint){
                let tFunction=tNode.getAccessibilityElement("startDragFunction")
                if(tFunction==nil){continue}
                //ノードの情報保持
                mDraggingNode=tNode
                mParentNode=tNode.parent
                mOriginalPoint=mDraggingNode.position
                mOriginalZPosition=mDraggingNode.zPosition
                mDraggingNode.removeFromParent()
                gGameViewController.get2dScene().addChild(mDraggingNode)
                mDraggingNode.position=tPoint
                //ドラッグ開始関数
                (tFunction as! (CGPoint)->())(tPoint)
                break
            }
        case .changed://パン入力
            if(mDraggingNode==nil){break}
            mDraggingNode.position=tPoint//ノード位置変更
            //ドラッグオーバーされたノード取得
            var tDragOverNode:SKNode?=nil
            for tNode in gGameViewController.get2dNodes(aPoint:tPoint){
                if(tNode === mDraggingNode){continue}
                if let _=tNode.getAccessibilityElement("dragOverFunction"){
                    tDragOverNode=tNode
                    break
                }
            }
            //ドラッグアウト処理
            if(mDragOverNode !== tDragOverNode){
                (mDraggingNode?.getAccessibilityElement("dragOutFunction") as? ()->())?()
            }
            else{
                break
            }
            //ドラッグオーバー処理
            mDragOverNode=tDragOverNode
            (mDragOverNode?.getAccessibilityElement("dragOverFunction") as? ()->())?()
        case .ended://パン終了
            if(mDraggingNode==nil){break}
            mDraggingNode.position=mOriginalPoint
            mDraggingNode.zPosition=mOriginalZPosition
            mDraggingNode.removeFromParent()
            mParentNode.addChild(mDraggingNode)
            (mDraggingNode.getAccessibilityElement("endDragFunction") as? (CGPoint)->())?(tPoint)
            //ドロップ処理
            if let tDragOverNode=mDragOverNode{
                if let tDropFunction=tDragOverNode.getAccessibilityElement("dropFunction"){
                    (tDropFunction as! (SKNode)->())(mDraggingNode)
                }
            }
            mDragOverNode=nil
            mDraggingNode=nil
        default:
            return
        }
    }
}
