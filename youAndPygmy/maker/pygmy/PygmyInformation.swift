//
//  PygmyInformation.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/29.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmyInformation{
    //情報表示
    static func set(aNode:SKNode,aPygmy:Pygmy){
        aNode.childNode(withName:"info")!.alpha=1
        BarMaker.blendBar(aNode:aNode.childNode(withName:"background")!,aColor:UIColor(red:0,green:0,blue:0,alpha:0),
                          aBlend:0)
        let tNode=aNode.childNode(withName:"info")!
        //キャライラスト
        if let tImageNode=tNode.childNode(withName:"image"){
            PygmyImageMaker.setImage(aNode:tImageNode,aImageData:aPygmy.getImage())
        }
        //名前
        (tNode.childNode(withName:"name") as? SKLabelNode)?.text=aPygmy.getName()
        //レベル
        (tNode.childNode(withName:"level") as? SKLabelNode)?.text=String(aPygmy.getLevel())
        //元気
        if let tHpBox=tNode.childNode(withName:"hpBox"){
            StatusBarMaker.setGage(
                aNode:tHpBox,
                aCurrent:aPygmy.getCurrentHp(),
                aMax:aPygmy.getStatus().hp
            )
        }
        //経験値
        if let tExperienceBox=tNode.childNode(withName:"experienceBox"){
            StatusBarMaker.setGage(
                aNode:tExperienceBox,
                aCurrent:aPygmy.getExperience(),
                aMax:aPygmy.getNextExperience()
            )
        }
        //アイテム
        if let tItemBox=tNode.childNode(withName:"itemBox"){
            ItemBarMaker.setItemLabel(
                aNode:tItemBox,
                aItem:aPygmy.getItem()
            )
        }
        //アクセサリ
        if let tAccessoryBox=tNode.childNode(withName:"accessoryBox"){
            ItemBarMaker.setAccessoryLabel(
                aNode:tAccessoryBox,
                aAccessory:aPygmy.getAccessory()
            )
        }
    }
    //ぴぐみーを表示しないノード
    static func blackOut(aNode:SKNode){
        aNode.childNode(withName:"info")!.alpha=0
        BarMaker.blendBar(aNode:aNode.childNode(withName:"background")!,aColor:UIColor(red:0,green:0,blue:0,alpha:1),
                          aBlend:0.4)
    }
}
