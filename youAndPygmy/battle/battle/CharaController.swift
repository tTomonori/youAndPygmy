//
//  CharaController.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class CharaController{
    static var mRoute:[(BattleTrout,[BattlePosition])]!//キャラの移動可能範囲とそこへの経路
    static func toAct(aChara:BattleChara){
        mRoute=RouteSearcher.search(aChara:aChara)
        for (tTrout,_) in mRoute{
            tTrout.changeColor(aColor:UIColor(red:0,green:0,blue:1,alpha:0.4))
        }
        gGameViewController.allowUserOperate()
    }
}
