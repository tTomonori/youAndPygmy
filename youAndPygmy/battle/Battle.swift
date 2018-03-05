//
//  Battle.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/04.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class Battle{
    private static var mScene:SCNScene!
    //戦闘情報をセット
    static func setBattle(aBattleData:BattleData){
        mScene=SCNScene()
    }
    //戦闘開始
    static func start(aEndFunction:(String)->()){
        aEndFunction("win")
    }
    //シーン表示
    static func display(){
        gGameViewController.set3dScene(aScene:mScene)
    }
}
