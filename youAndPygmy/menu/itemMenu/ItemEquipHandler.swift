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
    //装備する
    static func equip(aAccessory:String,aPygmy:Pygmy){
        let tAccessoryData=AccessoryDictionary.get(aAccessory)
        if(!YouBag.accessoryBag.remove(aItem:aAccessory,aNum:1)){
            TextAlert.alert(aText:"アクセサリが足りないよ")
            return
        }
        let tTakeOff=aPygmy.equipAccessory(aAccessory:aAccessory)
        if(tTakeOff.0){
            //装備できた
            TextAlert.alert(aText:aPygmy.getName()+"は"+tAccessoryData.name+"を装備したよ")
            if let tAccessory=tTakeOff.1{
                YouBag.accessoryBag.add(aItem:tAccessory,aNum:1)
            }
        }
        else{
            //装備できなかった
            TextAlert.alert(aText:"装備できないよ")
            YouBag.accessoryBag.add(aItem:aAccessory,aNum:1)
        }
    }
    //アクセサリを外す
    static func receiveAccessory(aPygmy:Pygmy){
        let tAccessory=aPygmy.takeOffAccessory()
        if(tAccessory==nil){return}
        YouBag.accessoryBag.add(aItem:tAccessory!,aNum:1)
    }
}
