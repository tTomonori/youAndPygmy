//
//  ItemEquipHandler.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/30.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemEquipHandler{
    static func equip(aAccessory:String,aPygmy:Pygmy){
        let tAccessoryData=AccessoryDictionary.get(aAccessory)
        print(aPygmy.getName()+"に"+tAccessoryData.name+"を装備する")
    }
}
