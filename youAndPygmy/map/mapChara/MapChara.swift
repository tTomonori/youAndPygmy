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
    var mCharaNode:PanelNode//ノード
    var mPosition:FeildPosition!//今いる座標
    var mDirection:String!//キャラが向いている方向
    var mTrout:MapTrout!//今いるマス
    var mOperationFlag:Bool=false//falseなら操作可能
    init(aPosition:FeildPosition,aImageName:String){
        //キャラ画像のノード生成
        mCharaNode=PanelNode(aWidth:gTroutSizeCG*1.2,aHeight:gTroutSizeCG*1.2)
        mCharaNode.setImage(aImage:aImageName,aWidthNum:3,aHeightNum:4)
        changeImage(aDirection: "down", aNum: 1)//キャラの向き
        //座標設定
        setPosition(aPosition:aPosition)
        
        mTrout.on(aChara:self)
    }
    //座標設定
    func setPosition(aPosition:FeildPosition){
        mPosition=aPosition
        mTrout=MapFeild.getTrout(aPosition: mPosition)!//乗っているマス設定
        mCharaNode.position =
            SCNVector3(x:gTroutSize*mPosition.x,
                       y:gTroutSize*Float(mTrout.getHeight(aDirection: "center")!),
                       z:gTroutSize*mPosition.z)
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
        mCharaNode.changeImage(aX: tX, aY: tY)
    }
    //移動
    func move(aDirection:String,aEndFunction:@escaping ((Bool)->())){
        //操作フラグ管理
        if(mOperationFlag){return}
        //キャラの向き変更
        changeImage(aDirection: aDirection, aNum: 1)
        //移動先のマス
        let tTrout:MapTrout?=MapFeild.getNeighborTrout(aPosition:mPosition,aDirection:aDirection)
        if(tTrout==nil||tTrout!.canOnNow()==false){aEndFunction(false);return}//指定した方向に移動できない
        //操作フラグ
        mOperationFlag=true
        animateMove(aDirection:aDirection,aTrout:tTrout!,aEndFunction:{()->()in self.mOperationFlag=false;aEndFunction(true)})
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
