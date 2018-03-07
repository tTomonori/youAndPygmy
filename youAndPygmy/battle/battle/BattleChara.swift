//
//  BattleChara.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class BattleChara{
    private let mNode:CharaNode
    init(aData:BattleCharaData,aPosition:BattlePosition){
        mNode=CharaNode.init(aData:aData.image)
        mNode.setPosition(aPosition:aPosition)
    }
    func getNode()->SCNNode{return mNode}
}
