//
//  PygmyObject.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class CharaObject{
    var mNode:SCNNode
    init(aImage:[String]){
        mNode=SCNNode()
        for i in 0..<aImage.count{
            let tImageName=aImage[i]
        }
    }
}
