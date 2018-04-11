//
//  TroutMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/09.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit
//マスの大きさ
var gTroutSize=Float(0.5);
var gTroutSizeCG=CGFloat(gTroutSize)
//マスのノードを生成する
class TroutMaker{
    private
    static let mGeometrySource = [SCNGeometrySource(vertices: gTroutVertices, count: gTroutVertices.count),
                          SCNGeometrySource(normals: gTroutNormals, count: gTroutNormals.count),
                          SCNGeometrySource(textureCoordinates: gTroutTexcoords)]
    public
    //地形ブロック生成
    static func createTrout(aShape:String,aDirection:String)->TroutNode{
        let tTrout=TroutNode()
        //形状
        switch aShape {
        case "box":
            tTrout.geometry=TroutMaker.createTroutGeometry()
            break;
        case "slop":
            tTrout.geometry=TroutMaker.createSlopeGeometry()
            break;
        default:print("マスの形状が不正だよ→",aShape);break
        }
        //向き
        switch aDirection {
        case "":break;
        case "up":tTrout.rotation=SCNVector4(0,1,0,Float.pi);break;
        case "down":break;
        case "left":tTrout.rotation=SCNVector4(0,1,0,Float.pi*(-0.5));break;
        case "right":tTrout.rotation=SCNVector4(0,1,0,Float.pi*0.5);break;
        default:print("マスの向きが変だよ→",aDirection);break;
        }
        return tTrout;
    }
    //立方体生成
    static func createTroutGeometry()->SCNGeometry{
        return SCNBox(width: gTroutSizeCG, height: gTroutSizeCG, length: gTroutSizeCG, chamferRadius: 0)
    }
    //三角柱(坂道)生成
    static func createSlopeGeometry()->SCNGeometry{
        // ポリゴン
        let tIndices: [Int32] = [
            // 奥
            4, 5, 7,
            4, 7, 6,
            // 左側
            8,10,11,
            // 右側
            13, 14, 15,
            // 上側
            16, 2, 17,
            17, 2, 3,
            // 下側
            22, 23, 20,
            23, 21, 20,
            ]
        // カスタムジオメトリ
        let tFaceSource = SCNGeometryElement(indices: tIndices, primitiveType: .triangles)
        let tCustomGeometry = SCNGeometry(sources: mGeometrySource, elements: [tFaceSource])

        return tCustomGeometry
    }
}
let gHalf=gTroutSize/2
//頂点座標
let gTroutVertices = [
    // 手前
    SCNVector3(-gHalf, +gHalf, +gHalf), // 手前+左上 0
    SCNVector3(+gHalf, +gHalf, +gHalf), // 手前+右上 1
    SCNVector3(-gHalf, -gHalf, +gHalf), // 手前+左下 2
    SCNVector3(+gHalf, -gHalf, +gHalf), // 手前+右下 3
    // 奥
    SCNVector3(-gHalf, +gHalf, -gHalf), // 奥+左上 4
    SCNVector3(+gHalf, +gHalf, -gHalf), // 奥+右上 5
    SCNVector3(-gHalf, -gHalf, -gHalf), // 奥+左下 6
    SCNVector3(+gHalf, -gHalf, -gHalf), // 奥+右下 7
    // 左側
    SCNVector3(-gHalf, +gHalf, -gHalf), // 8 (=4)
    SCNVector3(-gHalf, +gHalf, +gHalf), // 9 (=0)
    SCNVector3(-gHalf, -gHalf, -gHalf), // 10 (=6)
    SCNVector3(-gHalf, -gHalf, +gHalf), // 11 (=2)
    // 右側
    SCNVector3(+gHalf, +gHalf, +gHalf), // 12 (=1)
    SCNVector3(+gHalf, +gHalf, -gHalf), // 13 (=5)
    SCNVector3(+gHalf, -gHalf, +gHalf), // 14 (=3)
    SCNVector3(+gHalf, -gHalf, -gHalf), // 15 (=7)
    // 上側
    SCNVector3(-gHalf, +gHalf, -gHalf), // 16 (=4)
    SCNVector3(+gHalf, +gHalf, -gHalf), // 17 (=5)
    SCNVector3(-gHalf, +gHalf, +gHalf), // 18 (=0)
    SCNVector3(+gHalf, +gHalf, +gHalf), // 19 (=1)
    // 下側
    SCNVector3(-gHalf, -gHalf, +gHalf), // 20 (=2)
    SCNVector3(+gHalf, -gHalf, +gHalf), // 21 (=3)
    SCNVector3(-gHalf, -gHalf, -gHalf), // 22 (=6)
    SCNVector3(+gHalf, -gHalf, -gHalf), // 23 (=7)
]

// 各頂点におけるテクスチャ座標
let gTroutTexcoords:[CGPoint] = [
    // 手前
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
    // 奥
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
    // 左側
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
    // 右側
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
    // 上側
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
    // 下側
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
]

// 各頂点における法線ベクトル
let gTroutNormals:[SCNVector3] = [
    // 手前
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
    // 奥
    SCNVector3(0, 0, -1),
    SCNVector3(0, 0, -1),
    SCNVector3(0, 0, -1),
    SCNVector3(0, 0, -1),
    // 左側
    SCNVector3(-1, 0, 0),
    SCNVector3(-1, 0, 0),
    SCNVector3(-1, 0, 0),
    SCNVector3(-1, 0, 0),
    // 右側
    SCNVector3(1, 0, 0),
    SCNVector3(1, 0, 0),
    SCNVector3(1, 0, 0),
    SCNVector3(1, 0, 0),
    // 上側
    SCNVector3(0, 1, 0),
    SCNVector3(0, 1, 0),
    SCNVector3(0, 1, 0),
    SCNVector3(0, 1, 0),
    // 下側
    SCNVector3(0, -1, 0),
    SCNVector3(0, -1, 0),
    SCNVector3(0, -1, 0),
    SCNVector3(0, -1, 0),
]
