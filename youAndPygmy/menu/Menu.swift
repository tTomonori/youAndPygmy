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
    //表示に必要なオプション
    var mOptions:Dictionary<String,Any>!
    //閉じた時に実行する関数
    var mClosedFunction:(()->())!
    var mScene:SKScene!
    var mAccessFlag=false
    init(aName:String){
//        createScene()
//        setAction()
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
                tNode.setElement("tapEventType","run")
                tNode.setElement("tapFunction",{()->Void in self.close()})
            case "screen":
                tNode.setElement("tapEventType","block")
            default:break
            }
        }
    }
    //メニューを表示
    func display(aClosedFunction:@escaping ()->(),aOptions:Dictionary<String,Any>){
        if(!mAccessFlag){//初回表示
            createScene()
            setAction()
            mAccessFlag=true
        }
        mOptions=aOptions
        firstDisplay()
        renew()//表示更新
        mClosedFunction=aClosedFunction
        gGameViewController.set2dScene(aScene:mScene)
    }
    //メニューを表示して最初の処理
    func firstDisplay(){
    }
    //表示更新
    func renew(){
    }
    //メニューをさらに階層表示
    func displayChildMenu(aMenuName:String,aOptions:Dictionary<String,Any>){
        MenuParent.displayChildMenu(aMenuName:aMenuName,aOptions:aOptions)
    }
    //階層表示したメニューが閉じられた
    func closedChildMenu(){
        renew()
        gGameViewController.set2dScene(aScene:mScene)
    }
    //閉じる
    func close(){
        mClosedFunction()
    }
}
