//
//  ItemBarMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/26.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemBarMaker{
    //アイテム名セット
    static func setItemLabel(aNode:SKNode,aItem:(String?,Int)){
        let (tItem,tNum)=aItem
        let tLabel=aNode.childNode(withName:"label")!
        if(tItem != nil){
            //持ち物あり
            let tItemData=ItemDictionary.get(tItem!)
            (tLabel.childNode(withName:"name") as! SKLabelNode).text=tItemData.name
            (tLabel.childNode(withName:"x") as! SKLabelNode).text="x"
            (tLabel.childNode(withName:"number") as! SKLabelNode).text=String(tNum)
        }
        else{
            //持ち物なし
            (tLabel.childNode(withName:"name") as! SKLabelNode).text="なし"
            (tLabel.childNode(withName:"x") as! SKLabelNode).text=""
            (tLabel.childNode(withName:"number") as! SKLabelNode).text=""
        }
    }
    //アクセサリ名セット
    static func setAccessoryLabel(aNode:SKSpriteNode,aAccessory:String?){
        let tLabel=aNode.childNode(withName:"label")!
        if(aAccessory != nil){
            //持ち物あり
            let tAccessoryData=AccessoryDictionary.get(aAccessory!)
            (tLabel.childNode(withName:"name") as! SKLabelNode).text=tAccessoryData.name
        }
        else{
            //持ち物なし
            (tLabel.childNode(withName:"name") as! SKLabelNode).text="なし"
        }
    }
    //アイテムのバーセット
    static func setItemBar(aNode:SKNode,aItem:(String?,Int),aCategory:ItemCategory){
        if(aItem.0==nil){//アイテムなし
            aNode.alpha=0
            return
        }
        aNode.alpha=1
        let tNode=aNode.childNode(withName:"label")!
        switch aCategory {
        case .tool://どうぐ
            let tData=ItemDictionary.get(aItem.0!)
            tNode.childNode(withName:"canHave")?.alpha=(tData.maxNum>0) ?1:0
            (tNode.childNode(withName:"name") as? SKLabelNode)?.text=tData.name
            (tNode.childNode(withName:"number") as? SKLabelNode)?.text=String(aItem.1)
        case .accessory://アクセサリ
            let tData=AccessoryDictionary.get(aItem.0!)
            tNode.childNode(withName:"canHave")?.alpha=0
            (tNode.childNode(withName:"name") as? SKLabelNode)?.text=tData.name
            (tNode.childNode(withName:"number") as? SKLabelNode)?.text=String(aItem.1)
        case .important://大切なもの
            break
        case .fragment://カケラ
            break
        }
    }
}
