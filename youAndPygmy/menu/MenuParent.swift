//
//  SuperMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/23.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class MenuParent{
    //メニューを閉じた時に実行する関数
    static var mClosedFunction:(()->())!
    //メニューのリスト
    static var mMenuDictionary:Dictionary<String,Menu>=[:]
    //階層表示しているメニューのリスト
    static var mShownMenus:[Menu]=[]
    //表示する
    static func display(aMenuName:String,aClosedFunction:@escaping ()->(),aOptions:Dictionary<String,Any>){
        if(mMenuDictionary.count==0){initMenuDictionary()}
        mClosedFunction=aClosedFunction
        let tMenu=mMenuDictionary[aMenuName]!
        mShownMenus=[tMenu]
        tMenu.display(aClosedFunction:self.closed,aOptions:aOptions)
    }
    //メニューを階層表示
    static func displayChildMenu(aMenuName:String,aOptions:Dictionary<String,Any>){
        let tMenu=mMenuDictionary[aMenuName]!
        mShownMenus.append(tMenu)
        tMenu.display(aClosedFunction:self.closed,aOptions:aOptions)
    }
    //メニューが閉じられた
    static func closed(){
        _=mShownMenus.popLast()!
        if let tPreveousMenu=mShownMenus.last{
            tPreveousMenu.closedChildMenu()
        }
        else{
            //メニューが全て閉じられた
            mClosedFunction()
        }
    }
    //メニューを強制的に全て閉じる
    static func closeAll(){
        mShownMenus=[]
        mClosedFunction()
    }
    //メニュー初期化
    static func initMenuDictionary(){
        mMenuDictionary["main"]=MainMenu.singleton
        mMenuDictionary["pygmy"]=PygmyMenu.singleton
        mMenuDictionary["details"]=PygmyDetails.singleton
        mMenuDictionary["skill"]=SkillMenu.singleton
    }
}
