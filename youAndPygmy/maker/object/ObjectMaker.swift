//
//  ObjectMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/04.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class ObjectMaker{
    static func make(aObjectName:String)->SCNNode{
        switch aObjectName {
        case "grass":return createObject(aWidth:gTroutSizeCG,aHeight:gTroutSizeCG, aTextureName:"grassObject")
        default:print("不正なオブジェクト名だよ→",aObjectName)
        }
        return SCNNode()
    }
    static func createObject(aWidth:CGFloat,aHeight:CGFloat,aTextureName:String)->SCNNode{
        let tNode=PanelNode(aWidth:aWidth,aHeight:aHeight)
        tNode.setImage(aImage:aTextureName)
        return tNode
    }
}
