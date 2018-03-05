//
//  PlayerChara.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

var gPlayerChara:PlayerChara!=PlayerChara(aPosition:FeildPosition(x:0,y:0,z:0))
class PlayerChara : MapChara{
    init(aPosition:FeildPosition){
        super.init(aPosition: aPosition, aImageName: "chara")
    }
    //ユーザの操作による移動
    func inputMove(){
        //操作フラグ
        gGameViewController.denyUserOperate()
        let tDirection=PanOperator.getDirection()
        if(tDirection==""){gGameViewController.allowUserOperate();print("stay");return}
        print("moveStart")
        //移動
        move(aDirection:tDirection,aEndFunction:{(aResult)->()in
            print("moveEnd")
            if(!aResult){
                print("moveFalse")
                gGameViewController.allowUserOperate()
                return
            }
            print("moveTrue")
            //イベント処理
            MapEvent.runEvents(aEvents:self.mTrout.getEvent(),aEndFunction:{()->()in
                print("endEvent")
                MapUi.display()
                self.inputMove()
            })
        })
    }
}
