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
    private static var mPygmiesBox:[SKNode]!//ぴぐみーの情報表示するノード
    private static var mItemBar:SKNode=mScreen.childNode(withName:"itemBar")!//アイテムの個数表示ノード
    private static var mItemBarImageName:String=BarMaker.getBackgroundName(aNode:mItemBar)
    private static var mItemCategory:ItemCategory!//選択したアイテムのカテゴリ
    private static var mItem:String!//選択したアイテム
    private static var mPygmies:[Pygmy]!
    private static var mEndFunction:(()->())!
    private static func createScene()->SKNode{
        let tScene=SKScene(fileNamed:"itemConsumer")!
        let tScreen=tScene.childNode(withName:"screen")!
        tScreen.setElement("tapEventType","block")
        //戻るボタン
        tScreen.childNode(withName:"backButton")!.setElement("tapFunction",{()->()in self.hide()})
        mPygmiesBox=[]
        for i in 0...4{//ぴぐみーの情報ノード
            let tAccompanying=tScreen.childNode(withName:"accompanying"+String(i))!
            mPygmiesBox.append(tAccompanying)
            tAccompanying.setElement("tapFunction",{()->()in
                self.selecte(i)
            })
        }
        tScreen.removeFromParent()
        return tScreen
    }
    //使う
    static func use(aTool:String,aEndFunction:@escaping ()->()){
        mItem=aTool
        mItemCategory = .tool
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //持たせる
    static func toHave(aTool:String,aEndFunction:@escaping ()->()){
        mItem=aTool
        mItemCategory = .tool
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //装備する
    static func equip(aAccessory:String,aEndFunction:@escaping ()->()){
        mItem=aAccessory
        mItemCategory = .accessory
        mEndFunction=aEndFunction
        show()
        renew()
    }
    //ぴぐみー選択
    static func selecte(_ num:Int){
        print(num)
    }
    //表示
    static func show(){
        mPygmies=You.getAccompanying()
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
        mScreen.removeFromParent()
        mPygmies=nil
        mItem=nil
        mItemCategory=nil
    }
    //更新
    static func renew(){
        //ぴぐみーの情報
        let tPygmyNum=mPygmies.count
        for i in 0..<mPygmiesBox.count{
            if(i<tPygmyNum){
                PygmyInformation.set(aNode:mPygmiesBox[i],aPygmy:mPygmies[i])
            }
            else{
                PygmyInformation.blackOut(aNode:mPygmiesBox[i])
            }
        }
        //アイテムの個数
        let tItemNum=YouBag.getBag(mItemCategory).get(aItem:mItem)
        ItemBarMaker.setItemBar(aNode:mItemBar,aItem:(mItem,tItemNum.1),aCategory:mItemCategory)
    }
}
