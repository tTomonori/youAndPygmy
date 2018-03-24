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
    private static var mScene:SKScene=createScene()
    static func createScene()->SKScene{
        let tScene=SKScene(fileNamed: "mapUi")!
        //タップ時関数セット
        for tNode in tScene.children{
            if(tNode.name==nil){continue}
            switch tNode.name! {
            case "menu":
                tNode.setElement("tapFunction",{()->Void in SceneController.openMainMenu()})
            case "investigation":
                tNode.setElement("tapFunction",{()->Void in MapEvent.investigate()})
            default:break
            }
        }
        //マップ移動関数セット
        tScene.setElement("dragFunction",{(_:UIGestureRecognizer)->()in
            gPlayerChara.inputMove()
        })
        return tScene
    }
    static func display(){
        gGameViewController.set2dScene(aScene: mScene)
    }
    static func close(){
        gGameViewController.set2dScene(aScene:gEmptySprite)
    }
}
