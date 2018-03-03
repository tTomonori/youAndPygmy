//
//  Menu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class Menu{
    //閉じた時に実行する関数
    var mClosedFunction:(()->())!
    var mScene:SKScene!
    init(aName:String){
        createScene()
        setAction()
    }
    //メニューのシーンを生成
    func createScene(){
        
    }
    //メニュー共通のクリックイベント設定
    func setAction(){
        //タップ時関数セット
        for tNode in mScene.children{
            let tName=(tNode.name != nil) ? tNode.name!:""
            switch tName {
            case "back":
                tNode.accessibilityElements=["run",{()->Void in self.close()}]
            case "screen":
                tNode.accessibilityElements=["block"]
            default:break
            }
        }
    }
    //メニューを表示
    func display(aClosedFunction:@escaping ()->(),aOptions:Dictionary<String,Any>){
        renew(aOptions: aOptions)//表示更新
        mClosedFunction=aClosedFunction
        gGameViewController.set2dScene(aScene:mScene)
    }
    //表示更新
    func renew(aOptions:Dictionary<String,Any>){
        
    }
    //メニューをさらに階層表示
    func displayChildMenu(aMenuName:String,aOptions:Dictionary<String,Any>){
        MenuParent.displayChildMenu(aMenuName:aMenuName,aOptions:aOptions)
    }
    //階層表示したメニューが閉じられた
    func closedChildMenu(){
        gGameViewController.set2dScene(aScene:mScene)
    }
    //閉じる
    func close(){
        mClosedFunction()
    }
}
