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
    //アイテムを持たせる
    static func toHave(aItem:String,aNum:Int,aPygmy:Pygmy){
        let tItem=aPygmy.getItem()
        if(aItem==tItem.0){
            //持たせるアイテムをすでに所持している
            if(tItem.1<aNum){//追加で持たせる
                if(YouBag.toolBag.remove(aItem:aItem,aNum:aNum-tItem.1)){
                    let _=aPygmy.haveItem(aItem:aItem,aNum:aNum)
                }
                else{
                    TextAlert.alert(aText:"数が足りないよ")
                    return
                }
            }
            else if(aNum<tItem.1){//一部預かる
                let _=aPygmy.haveItem(aItem:aItem,aNum:aNum)
                YouBag.toolBag.add(aItem:aItem,aNum:tItem.1-aNum)
            }
            else{//指定数をすでに所持している
                
            }
        }
        else{
            //アイテムを持たせ変えるor何も持っていなかった
            if(YouBag.toolBag.remove(aItem:aItem,aNum:aNum)){
                let tItem=aPygmy.haveItem(aItem:aItem,aNum:aNum)
                if(tItem.0 != nil){
                    YouBag.toolBag.add(aItem:tItem.0!,aNum:tItem.1)//預かったアイテムをバッグへ
                }
            }
            else{
                TextAlert.alert(aText:"数が足りないよ")
                return
            }
        }
    }
    //アイテムを預かる
    static func receiveItems(aPygmy:Pygmy){
        let tItem=aPygmy.returnItem()
        if(tItem.0==nil){return}
        YouBag.toolBag.add(aItem:tItem.0!,aNum:tItem.1)
    }
    //すでに持っているアイテムを持てるだけ渡す
    static func toHaveMax(aPygmy:Pygmy){
        let tItem=aPygmy.getItem()
        if(tItem.0==nil){return}
        let tBagItem=YouBag.toolBag.get(aItem:tItem.0!)
        let tMaxNum=ItemDictionary.get(tItem.0!).maxNum
        if(tMaxNum<=tItem.1+tBagItem.1){
            //最大数持たせられる
            let _=aPygmy.haveItem(aItem:tItem.0!,aNum:tMaxNum)
            let _=YouBag.toolBag.remove(aItem:tItem.0!,aNum:tMaxNum-tItem.1)
        }
        else{
            //最大までは持たせられない
            let _=aPygmy.haveItem(aItem:tItem.0!,aNum:tItem.1+tBagItem.1)
            let _=YouBag.toolBag.remove(aItem:tItem.0!,aNum:tBagItem.1)
        }
    }
}
