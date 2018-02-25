//
//  MainMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu:Menu{
    static let singleton:MainMenu=MainMenu()
    private init(){
        super.init(aName:"main")
    }
    override func createScene(){
        mScene=SKScene(fileNamed: "mainMenu")!
        //タップ時関数セット
        for tNode in mScene.children{
            let tName=(tNode.name != nil) ? tNode.name!:"label"
            switch tName {
            case "pygmy":
                tNode.accessibilityElements=["run",{()->Void in self.displayChildMenu(aMenuName:"pygmy")}]
            case "item":
                tNode.accessibilityElements=["run",{()->Void in print("item")}]
            case "book":
                tNode.accessibilityElements=["run",{()->Void in print("book")}]
            case "save":
                tNode.accessibilityElements=["run",{()->Void in print("save")}]
            default:
                tNode.accessibilityElements=["none"]
            }
        }
    }
}
