//
//  Map.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/09.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

//現在のマップ
class MapFeild{
    private
    static var mMapData:MapData!
    static var mScene=SCNScene()
    static var mTrouts:Dictionary<String,MapTrout>!
    static var mNpcs:Dictionary<String,MapChara>!
    static var mTroutSize=Float(gTroutSize)
    static var mCameraNode:SCNNode!
    public
    //現在のマップを設定
    static func setMap(aMapData:MapData){
        mMapData=aMapData
        mScene=SCNScene();
        mTrouts=[:]
        mNpcs=[:]
        //マップチップデータをセット
        MapTroutMaker.setMapChip(aData:aMapData.chipData)
        for (tY,tFloors) in aMapData.troutData{//Y=高さ
            for (tZ,tLines) in tFloors{//Z=前後
                for tX in 0 ..< tLines.count{//X=左右
                    let tChipNum=tLines[tX]
                    if(tChipNum == 0){mTrouts[makeTroutKey(aX:tX,aY:tY,aZ:tZ)]=nil;continue;}//なにもないマス
                    let tTrout=MapTroutMaker.makeTrout(aChipNum:tChipNum,aPosition:FeildPosition(x:tX,y:tY,z:tZ))
                    //生成したノードを追加
                    mTrouts[makeTroutKey(aX:tX,aY:tY,aZ:tZ)]=tTrout
                    mScene.rootNode.addChildNode(tTrout.getNode())
                }
            }
        }
        //特殊なマスセット
        for tTroutData in aMapData.specialTrout{
            let tPosition=tTroutData["position"] as! FeildPosition
            let tTrout=MapTroutMaker.makeTroutWithChipData(aPosition:tPosition,
                                                           aChip:tTroutData["chip"] as! Dictionary<String, Any>)
            //生成したノードを追加
            mTrouts[makeTroutKey(aX:tPosition.x,aY:tPosition.y,aZ:tPosition.z)]=tTrout
            mScene.rootNode.addChildNode(tTrout.getNode())
        }
        //npcデータセット
        for tNpcData in aMapData.npcData{
            let tNpc=NonPlayerChara(aData:tNpcData)
            tNpc.changeImage(aDirection:tNpcData.direction, aNum:1)
            mNpcs[tNpcData.name]=tNpc
            mScene.rootNode.addChildNode(tNpc.getNode())
        }
        //カメラ
        mCameraNode=SCNNode()
        mCameraNode.camera=SCNCamera()
        mCameraNode.rotation=SCNVector4(-1,0,0,0.2*Float.pi)
    }
    //マスのインスタンスを特定するキーを生成
    static func makeTroutKey(aX:Int,aY:Int,aZ:Int)->String{
    return String(aX)+","+String(aY)+","+String(aZ)
    }
    //自キャラ配置
    static func setHero(aPosition:FeildPosition){
        //自キャラ
        gPlayerChara=PlayerChara(aPosition: aPosition)
        mScene.rootNode.addChildNode(gPlayerChara.getNode())
    }
    //カメラを主人公に追従させる
    static func makeCameraFollowHero(){
        gPlayerChara.followCamera(aCamera:mCameraNode)
    }
    //フィールドを表示
    static func display(){
        gGameViewController.set3dScene(aScene: mScene)
    }
    //マス取得
    static func getTrout(aPosition:FeildPosition)->MapTrout?{
        //マップ外の座標を指定した場合はnilを返す
        return mTrouts[makeTroutKey(aX:aPosition.x,aY:aPosition.y,aZ:aPosition.z)]
    }
    //指定方向のマス取得
    static func getNeighborTrout(aPosition:FeildPosition,aDirection:String)->MapTrout?{
        //移動方向の逆方向
        let tReverseDirection=getReverseDirection(aDirection: aDirection)
        //現在いるマスの移動方向の高さ
        let tFloorHeight=MapFeild.getTrout(aPosition:aPosition)!.getHeight(aDirection: aDirection)
        //移動先の座標
        var tPosition:FeildPosition!
        switch aDirection {
        case "up":tPosition=FeildPosition(x:aPosition.x,y:aPosition.y,z:aPosition.z-1)
        case "down":tPosition=FeildPosition(x:aPosition.x,y:aPosition.y,z:aPosition.z+1)
        case "left":tPosition=FeildPosition(x:aPosition.x-1,y:aPosition.y,z:aPosition.z)
        case "right":tPosition=FeildPosition(x:aPosition.x+1,y:aPosition.y,z:aPosition.z)
        default:print("不正な移動方向指定→",aDirection)
        }
        var tTrout:MapTrout?
        for i in [1,0,-1]{
            tTrout=MapFeild.getTrout(aPosition:FeildPosition(x:tPosition.x,y:tPosition.y+i,z:tPosition.z))
            if(tTrout==nil){continue}//マスがない
            if(tFloorHeight != tTrout!.getHeight(aDirection:tReverseDirection)){continue}//移動先と高さが合わない
            //上にマスがある
            if(MapFeild.getTrout(aPosition:FeildPosition(x:tPosition.x,y:tPosition.y+i+1,z:tPosition.z)) != nil){continue}
            return tTrout
        }
        //移動できない
        return nil
    }
}
