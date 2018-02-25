//
//  MapCahra.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

//マス間の移動速度
var gMoveSpeed:Double=0.2

class MapChara{
    private
    static let mGeometrySource = [SCNGeometrySource(vertices: gMapCharaVertices, count: gMapCharaVertices.count),
                                  SCNGeometrySource(normals: gMapCharaNormals, count: gMapCharaNormals.count),
                                  SCNGeometrySource(textureCoordinates: gMapCharaTexcoords)]
    var mGeometry:SCNGeometry=SCNGeometry(sources: mGeometrySource, elements: [gPlaneFaceSource])
    var mCharaImage:UIImage!
    var mCharaNode:SCNNode//ノード
    var mPosition:FeildPosition//今いる座標
    var mDirection:String!//キャラが向いている方向
    var mTrout:MapTrout//今いるマス
    var mOperationFlag:Bool=false//falseなら操作可能
    var mMaterials:[[SCNMaterial]]
    public
    init(aPosition:FeildPosition,aImageName:String){
        mCharaImage=UIImage(named:aImageName)!//画像設定
        mCharaNode=SCNNode(geometry:mGeometry)//ノード生成
        //座標設定
        mPosition=aPosition
        mTrout=MapFeild.getTrout(aPosition: mPosition)!//乗っているマス設定
        mCharaNode.position =
            SCNVector3(x:gTroutSize*mPosition.x,
                       y:gTroutSize*Float(mTrout.getHeight(aDirection: "center")!),
                       z:gTroutSize*mPosition.z)
        //キャラ画像マテリアル生成
        mMaterials=[]
        for tX in 0...2{
            mMaterials.append([])
            for tY in 0...3{
                //画像読み込み&カット
                let tImage=mCharaImage.cgImage!.cropping(to:
                    CGRect(x:mCharaImage.size.width/3*CGFloat(tX),y:mCharaImage.size.height/4*CGFloat(tY),
                           width:mCharaImage.size.width/3,height:mCharaImage.size.height/4))
                //テクスチャ
                let tMaterial = SCNMaterial()
                tMaterial.diffuse.contents=tImage
                mMaterials[tX].append(tMaterial)
            }
        }
        changeImage(aDirection: "down", aNum: 1)//キャラの向き
        
        mTrout.on(aChara:self)
    }
    //ノード取得
    func getNode()->SCNNode{return mCharaNode}
    //座標取得
    func getPosition()->FeildPosition{return mPosition}
    //キャラの向き取得
    func getDirection()->String{return mDirection}
    //キャラ画像変更
    func changeImage(aDirection:String,aNum:Int){
        let tX=aNum
        var tY=0
        switch aDirection {
        case "up":tY=3
        case "down":tY=0
        case "left":tY=1
        case "right":tY=2
        default:return
        }
        mDirection=aDirection
        //テクスチャ
        mCharaNode.geometry!.materials=[mMaterials[tX][tY]]
    }
    //移動
    func move(aDirection:String,aEndFunction:@escaping (()->())){
        //操作フラグ管理
        if(mOperationFlag){return}
        //キャラの向き変更
        changeImage(aDirection: aDirection, aNum: 1)
        //移動先のマス
        let tTrout:MapTrout?=MapFeild.getNeighborTrout(aPosition:mPosition,aDirection:aDirection)
        if(tTrout==nil||tTrout!.canOnNow()==false){return}//指定した方向に移動できない
        //操作フラグ
        mOperationFlag=true
        animateMove(aDirection:aDirection,aTrout:tTrout!,aEndFunction:{()->()in self.mOperationFlag=false;aEndFunction()})
    }
    //移動アニメーション
    func animateMove(aDirection:String,aTrout:MapTrout,aEndFunction:@escaping (()->())){
        mTrout.out()
        aTrout.on(aChara:self)
        let (tOutMoveAction,tOutImageAction)=mTrout.getOutAction(aDirection:aDirection,aChara:self)
        let (tInMoveAction,tInImageAction)=aTrout.getInAction(aDirection:aDirection,aChara:self)
        mCharaNode.runAction(SCNAction.sequence([tOutMoveAction,tInMoveAction,SCNAction.run({(_)->()in aEndFunction()})]))
        mCharaNode.runAction(SCNAction.sequence([tOutImageAction,tInImageAction]))
        mTrout=aTrout
        mPosition=aTrout.getPosition()
    }
    //カメラを追従させる
    func followCamera(aCamera:SCNNode){
        aCamera.position=SCNVector3(x:0,y:gTroutSize*2.7,z:gTroutSize*4)
        mCharaNode.addChildNode(aCamera)
    }
    //話しかけた(調べた)時のイベントを取得
    func getSpeakEvents()->[Dictionary<String,Any>]{
        return []
    }
}
//頂点座標
let gMapCharaVertices = [
    SCNVector3(-gHalf*1.2, +gHalf*1.4, 0), // 左上 0
    SCNVector3(+gHalf*1.2, +gHalf*1.4, 0), // 右上 1
    SCNVector3(-gHalf*1.2, -gHalf, 0), // 左下 2
    SCNVector3(+gHalf*1.2, -gHalf, 0), // 右下 3
]
// 各頂点における法線ベクトル
let gMapCharaNormals = [
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
    SCNVector3(0, 0, 1),
]
//ポリゴン
let gMapCharaIndices: [Int32] = [
    0,2,1,
    1,2,3
]
// 各頂点におけるテクスチャ座標
let gMapCharaTexcoords:[CGPoint]=[
    CGPoint(x:0, y:0),
    CGPoint(x:1, y:0),
    CGPoint(x:0, y:1),
    CGPoint(x:1, y:1),
]
let gPlaneFaceSource = SCNGeometryElement(indices: gMapCharaIndices, primitiveType: .triangles)
