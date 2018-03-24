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
                tNode.setElement("tapFunction",{()->() in
                    self.displayChildMenu(aMenuName:"pygmy",aOptions:[:])})
            case "item":
                tNode.setElement("tapFunction",{()->() in print("item")})
            case "book":
                tNode.setElement("tapFunction",{()->() in print("book")})
            case "save":
                tNode.setElement("tapFunction",{()->() in print("save")})
            default:
                break
            }
        }
    }
}
