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
    // 各頂点における法線ベクトル
    static let mNormals = [
        SCNVector3(0, 0, 1),
        SCNVector3(0, 0, 1),
        SCNVector3(0, 0, 1),
        SCNVector3(0, 0, 1),
    ]
    //ポリゴン
    static let mIndices: [Int32] = [
        0,2,1,
        1,2,3
    ]
    // 各頂点におけるテクスチャ座標
    static let mTexcoords:[CGPoint]=[
        CGPoint(x:0, y:0),
        CGPoint(x:1, y:0),
        CGPoint(x:0, y:1),
        CGPoint(x:1, y:1),
    ]
    static func make(aObjectName:String)->SCNNode{
        switch aObjectName {
        case "grass":return createObject(aWidth:gTroutSizeCG,aHeight:gTroutSizeCG, aTextureName:"grassObject")
        default:print("不正なオブジェクト名だよ→",aObjectName)
        }
        return SCNNode()
    }
    static func createObject(aWidth:CGFloat,aHeight:CGFloat,aTextureName:String)->SCNNode{
        //頂点座標
        let tVertices = [
            SCNVector3(-aWidth/2, +aHeight, 0), // 左上 0
            SCNVector3(+aWidth/2, +aHeight, 0), // 右上 1
            SCNVector3(-aWidth/2, 0, 0), // 左下 2
            SCNVector3(+aWidth/2, 0, 0), // 右下 3
        ]
        let tPlaneFaceSource = SCNGeometryElement(indices: mIndices, primitiveType: .triangles)
        let tGeometrySource = [SCNGeometrySource(vertices: tVertices, count: tVertices.count),
                                              SCNGeometrySource(normals: mNormals, count: mNormals.count),
                                              SCNGeometrySource(textureCoordinates: mTexcoords)]
        let tGeometry:SCNGeometry=SCNGeometry(sources: tGeometrySource, elements: [tPlaneFaceSource])
        //マテリアル
        let tMaterial = SCNMaterial()
        tMaterial.diffuse.contents=UIImage(named:aTextureName)
        let tNode=SCNNode(geometry: tGeometry)
        tNode.geometry!.materials=[tMaterial]
        return tNode
    }
}
