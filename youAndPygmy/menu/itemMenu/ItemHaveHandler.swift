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
}
