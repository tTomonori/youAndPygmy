//
//  MapUi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class MapUi{
    static var mScene:SKScene!
    static func display(){
        let mScene=SKScene(fileNamed: "mapUi")!
        gGameViewController.set2dScene(aScene: mScene)
        //タップ時関数セット
        for tNode in mScene.children{
            if(tNode.name==nil){continue}
            switch tNode.name! {
            case "menu":
                tNode.accessibilityElements=["run",{()->Void in SceneController.openMainMenu()}]
            case "investigation":
                tNode.accessibilityElements=["run",{()->Void in MapEvent.investigate()}]
            default:break
            }
        }
        //マップ移動関数セット
        mScene.accessibilityElements=[{(_:UIGestureRecognizer)->()in
            gPlayerChara.inputMove()
//            let tDirection=PanOperator.getDirection()
//            if(tDirection==""){return}
//            var tMoveFunction:((String)->())!
//            tMoveFunction={(aDirection:String)->()in
//                gPlayerChara.move(aDirection:aDirection,aEndFunction:{()->()in
//                    let tDirection=PanOperator.getDirection()
//                    if(tDirection != ""){
//                        tMoveFunction(tDirection)
//                    }
//                })
//            }
//            tMoveFunction(tDirection)
            }]
    }
    static func close(){
        gGameViewController.set2dScene(aScene:gEmptySprite)
    }
}
