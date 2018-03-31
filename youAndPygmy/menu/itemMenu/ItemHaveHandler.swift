//
//  ItemHaveHandler.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/30.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemHaveHandler{
    static func toHave(aItem:String,aPygmy:Pygmy){
        let tItemData=ItemDictionary.get(aItem)
        print(aPygmy.getName()+"に"+tItemData.name+"を持たせる")
    }
}
