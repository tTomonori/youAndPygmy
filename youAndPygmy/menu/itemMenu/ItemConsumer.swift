//
//  ItemConsumer.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/29.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemConsumer{
    private static let mScreen:SKNode=createScene()
    private static let mSelector:SKNode=mScreen.childNode(withName:"selector")!//ぴぐみーの情報表示ノード
    private static let mItemBar:SKNode=mScreen.childNode(withName:"itemBar")!//アイテムの個数表示ノード
    private static var mItemBarImageName:String=BarMaker.getBackgroundName(aNode:mItemBar)
    private static var mItemCategory:ItemCategory!//選択したアイテムのカテゴリ
    private static var mItem:String!//選択したアイテム
    private static var mHandle:String!//アイテムをどうするか
    private static var mEndFunction:(()->())!
    private static func createScene()->SKNode{
        let tScene=SKScene(fileNamed:"itemConsumer")!
        let tScreen=tScene.childNode(withName:"screen")!
        tScreen.setElement("tapEventType","block")
        //戻るボタン
        tScreen.childNode(withName:"backButton")!.setElement("tapFunction",{()->()in self.hide()})
        //ぴぐみー表示ノード
        (tScreen.childNode(withName:"selector") as! SKSpriteNode).color=UIColor(red:0,green:0,blue:0,alpha:0)
        
        tScreen.removeFromParent()
        return tScreen
    }
    //使う
    static func use(aTool:String,aEndFunction:@escaping ()->()){
        mHandle="use"
        mItem=aTool
        mItemCategory = .tool
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //持たせる
    static func toHave(aTool:String,aEndFunction:@escaping ()->()){
        mHandle="toHave"
        mItem=aTool
        mItemCategory = .tool
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //装備する
    static func equip(aAccessory:String,aEndFunction:@escaping ()->()){
        mHandle="equip"
        mItem=aAccessory
        mItemCategory = .accessory
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //ぴぐみー選択
    static func selected(aPygmy:Pygmy){
        switch mHandle {
        case "use":ItemUseHandler.use(aItem:mItem,aPygmy:aPygmy)//使う
        case "toHave":ItemHaveHandler.toHave(aItem:mItem,aNum:1,aPygmy:aPygmy)//持たせる
        case "equip":ItemEquipHandler.equip(aAccessory:mItem,aPygmy:aPygmy)//装備する
        default:
            print("アイテムをどうしようっていうの→",mHandle)
        }
        renew()
    }
    //表示
    static func show(){
        //ぴぐみーセレクタ
        PygmySelector.show(aNode:mSelector,aFunction:self.selected)
        //アイテムの個数表示ノードの色変更
        var tColor:String
        switch mItemCategory! {
        case .tool://どうぐ
            tColor="green"
        case .accessory://アクセサリ
            tColor="yellow"
        case .important://大切なもの
            tColor="purple"
        case .fragment://カケラ
            tColor="blue"
        }
        BarMaker.setBarImage(aNode:mItemBar.childNode(withName:"background")!,aBarName:tColor+mItemBarImageName)
        gGameViewController.addOverlayNode(aNode:mScreen)
    }
    //非表示
    static func hide(){
        PygmySelector.hide()
        mScreen.removeFromParent()
        mItem=nil
        mItemCategory=nil
        mHandle=nil
        mEndFunction()
    }
    //更新
    static func renew(){
        //ぴぐみーの情報
        PygmySelector.renew()
        //アイテムの個数
        let tItemNum=YouBag.getBag(mItemCategory).get(aItem:mItem)
        ItemBarMaker.setItemBar(aNode:mItemBar,aItem:(mItem,tItemNum.1),aCategory:mItemCategory)
    }
}
