//
//  PanelNode.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/06.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class PanelNode:SCNNode{
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
    
    private var mMaterials:Dictionary<String,SCNMaterial>!//画像変更する場合のマテリアル
    private var mDividedMaterials:[[SCNMaterial]]!//画像分割表示する場合のマテリアル
    init(aWidth:CGFloat,aHeight:CGFloat){
        super.init()
        //頂点座標
        let tVertices = [
            SCNVector3(-aWidth/2, +aHeight, 0), // 左上 0
            SCNVector3(+aWidth/2, +aHeight, 0), // 右上 1
            SCNVector3(-aWidth/2, 0, 0), // 左下 2
            SCNVector3(+aWidth/2, 0, 0), // 右下 3
        ]
        let tPlaneFaceSource = SCNGeometryElement(indices: PanelNode.mIndices, primitiveType: .triangles)
        let tGeometrySource = [SCNGeometrySource(vertices: tVertices, count: tVertices.count),
                               SCNGeometrySource(normals: PanelNode.mNormals, count: PanelNode.mNormals.count),
                               SCNGeometrySource(textureCoordinates: PanelNode.mTexcoords)]
        let tGeometry:SCNGeometry=SCNGeometry(sources: tGeometrySource, elements: [tPlaneFaceSource])
        self.geometry=tGeometry
    }
    //SCNNodeを継承し、イニシャライザを実装するなら必要(らしい?)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //透明にする
    func toPenetrate(){
        let tMaterial=SCNMaterial()
        tMaterial.diffuse.contents=UIColor(red:0,green:0,blue:0,alpha:0)
        self.geometry!.materials=[tMaterial]
    }
    ////////////////////////////////////////
    //画像設定(画像変更しない場合)
    func setImage(aImage:String){
        let tMaterial = SCNMaterial()
        tMaterial.diffuse.contents=UIImage(named:aImage)
        self.geometry!.materials=[tMaterial]
    }
    ////////////////////////////////////////
    //画像設定(画像変更する場合)
    func setImage(aImages:Dictionary<String,String>){
        mMaterials=[:]
        for (tKey,tImageName) in aImages{
            let tMaterial=SCNMaterial()
            tMaterial.diffuse.contents=UIImage(named:tImageName)
            mMaterials[tKey]=tMaterial
        }
    }
    //画像変更
    func changeImage(aKey:String){
        self.geometry!.materials=[mMaterials[aKey]!]
    }
    ////////////////////////////////////////
    //画像設定(分割表示する場合)
    func setImage(aImage:String,aWidthNum:Int,aHeightNum:Int){
        //キャラ画像マテリアル生成
        mDividedMaterials=[]
        let tOriginalImage=UIImage(named:aImage)!
        let tWidth=tOriginalImage.size.width/CGFloat(aWidthNum)
        let tHeight=tOriginalImage.size.height/CGFloat(aHeightNum)
        for tX in 0..<aWidthNum{
            mDividedMaterials.append([])
            for tY in 0..<aHeightNum{
                //画像読み込み&カット
                let tImage=tOriginalImage.cgImage!.cropping(to:
                    CGRect(x:tWidth*CGFloat(tX),
                           y:tHeight*CGFloat(tY),
                           width:tWidth,
                           height:tHeight))
                //テクスチャ
                let tMaterial = SCNMaterial()
                tMaterial.diffuse.contents=tImage
                mDividedMaterials[tX].append(tMaterial)
            }
        }
    }
    //画像変更
    func changeImage(aX:Int,aY:Int){
        self.geometry!.materials=[mDividedMaterials[aX][aY]]
    }
}
