//
//  ItemUseHandler.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/30.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemUseHandler{
    static func use(aItem:String,aPygmy:Pygmy){
        let tItemData=ItemDictionary.get(aItem)
        let tConsume={()->(Bool)in//消費
            if(!YouBag.toolBag.remove(aItem:aItem,aNum:1)){//アイテムが足りない
                TextAlert.alert(aText:"アイテムが足りないよ")
                return false
            }
            return true
        }
        //効果
        switch tItemData.useEffect!.effect! {
        case .allHeal://全体回復
            for tPygmy in You.getAccompanying(){
                if(tPygmy.getCurrentHp()==tPygmy.getStatus().hp){continue}//hp満タン
                if(tConsume()){//アイテムが使える
                    for tPygmy2 in You.getAccompanying(){
                        tPygmy2.heal(aHeal:calcuHeal(aEffect:tItemData.useEffect!,aPygmy:tPygmy2))
                    }
                }
                return
            }
            //全員hp満タン
            TextAlert.alert(aText:"使っても効果がないよ")
            return
        case .oneHeal://一人回復
            if(aPygmy.getCurrentHp()==aPygmy.getStatus().hp){//hp満タン
                TextAlert.alert(aText:"使っても効果がないよ")
                return
            }
            if(tConsume()){//アイテムが使える
                aPygmy.heal(aHeal:calcuHeal(aEffect:tItemData.useEffect!,aPygmy:aPygmy))
            }
        }
    }
    //回復量取得
    static func calcuHeal(aEffect:UseEffect,aPygmy:Pygmy)->Int{
        switch aEffect.option["correction"] as! PowerCorrectType {
        case .addition://加算
            return 0
        case .multiplication://乗算
            return 0
        case .constant://固定
            return aEffect.option["value"] as! Int
        }
    }
}
