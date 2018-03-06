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
        if(tDirection==""){gGameViewController.allowUserOperate();return}
        //移動
        move(aDirection:tDirection,aEndFunction:{(aResult)->()in
            if(!aResult){
                gGameViewController.allowUserOperate()
                return
            }
            //イベント処理
            MapEvent.runEvents(aEvents:self.mTrout.getEvent(),aEndFunction:{()->()in
                MapUi.display()
                self.inputMove()
            })
        })
    }
}
