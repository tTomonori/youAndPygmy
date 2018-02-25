//
//  PlayerChara.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

var gPlayerChara:PlayerChara!
class PlayerChara : MapChara{
    init(aPosition:FeildPosition){
        super.init(aPosition: aPosition, aImageName: "chara")
    }
    //キャラの移動
    override func animateMove(aDirection: String, aTrout: MapTrout, aEndFunction: @escaping (() -> ())) {
        gGameViewController.denyUserOperate()
        super.animateMove(aDirection:aDirection,aTrout:aTrout,aEndFunction:{()->()in
            MapEvent.runEvents(aEvents:self.mTrout.getEvent(),aEndFunction:{()->()in
                MapUi.display()
                gGameViewController.allowUserOperate()
                aEndFunction()
            })
        })
    }
}
