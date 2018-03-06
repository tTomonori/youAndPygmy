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
    private let mNode:SCNNode
    init(aData:BattleCharaData,aPosition:BattlePosition){
        mNode=SCNNode()
    }
    func getNode()->SCNNode{return mNode}
}
