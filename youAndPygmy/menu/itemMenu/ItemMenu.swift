//
//  ItemMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/25.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemMenu:Menu{
    static let singleton:ItemMenu=ItemMenu()
    private init(){
        super.init(aName:"item")
    }
    override func createScene(){
        mScene=SKScene(fileNamed: "itemMenu")!
    }
}
