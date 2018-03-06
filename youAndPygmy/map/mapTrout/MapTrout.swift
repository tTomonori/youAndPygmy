//
//  MapTrout.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit
//マップのマス
class MapTrout{
    var mTrout:TroutNode//ノード
    var mCanOn:Bool!//このマスが通れるか
    var mEvents:[Dictionary<String,Any>]!//このマスに乗った時のイベント
    //マスの各方向の高さ(nilなら通過不可)
    var mCenterHeight:CGFloat!
    var mUpHeight:CGFloat!
    var mDownHeight:CGFloat!
    var mLeftHeight:CGFloat!
    var mRightHeight:CGFloat!
    //このマスにいるキャラ
    var mOnChara:MapChara?=nil
    //このマスにある物体
    var mObject:SCNNode?
    //このマスの座標
    var mPosition:FeildPosition!
    public
    init(aShape:String,aDirection:String) {
        //ノード生成
        mTrout=TroutMaker.createTrout(aShape:aShape,aDirection:aDirection)
        //マスの高さ設定
        setHeight(aDirection:aDirection)
    }
    //座標設定
    func setPosition(aPosition:FeildPosition){
        mPosition=aPosition
        mTrout.setPosition(aPosition:mPosition)
    }
    //マップチップ設定
    func setChip(aChip:Dictionary<String,Any>){
        mCanOn=(aChip["canOn"] != nil) ? aChip["canOn"] as! Bool:true
        mEvents=(aChip["event"] != nil) ? aChip["event"] as! [Dictionary<String,Any>]:[]
        mTrout.changeTerrain(aTerrain:aChip["terrain"] as! String)
        //物体
        if let tObjectName=aChip["object"]{
            mTrout.addObject(aObjectName:tObjectName as! String)
        }
    }
    //マスの高さ取得
    func getHeight(aDirection:String)->CGFloat?{
        switch aDirection {
        case "center":return CGFloat(mPosition.y)+mCenterHeight-0.5
        case "up":return CGFloat(mPosition.y)+mUpHeight-0.5
        case "down":return CGFloat(mPosition.y)+mDownHeight-0.5
        case "left":return CGFloat(mPosition.y)+mLeftHeight-0.5
        case "right":return CGFloat(mPosition.y)+mRightHeight-0.5
        default:print("謎な位置の高さを取得しようとしたよ→",aDirection)
        }
        return nil
    }
    //マスの座標を取得
    func getPosition()->FeildPosition{
        return mPosition
    }
    //ノードを取得(シーン追加用)
    func getNode()->SCNNode{
        return mTrout
    }
    //このマスが通れるか
    func canOn()->Bool{
        return mCanOn
    }
    //現在このマスに移動することができるか
    func canOnNow()->Bool{
        if(mOnChara != nil){return false}//このマスにキャラがいる
        return mCanOn
    }
    //このマスに乗った時のイベント
    func getEvent()->[Dictionary<String,Any>]{
        return mEvents
    }
    //キャラが乗った
    func on(aChara:MapChara){
        if(mOnChara != nil){print("MapTrout:同じマスにキャラが複数乗った")}
        mOnChara=aChara
    }
    //キャラが移動した
    func out(){
        mOnChara=nil
    }
    //このマスにいるキャラを取得
    func getChara()->MapChara?{
        return mOnChara
    }
    //マス移動アニメーションにキャラのテクスチャ変更処理を加えたアクションを生成
    //出て行く場合
    func makeOutMoveAction(x:CGFloat,y:CGFloat,z:CGFloat,duration:TimeInterval,chara:MapChara,direction:String)->
        (SCNAction,SCNAction){
        return (SCNAction.moveBy(x:x,y:y,z:z,duration:duration),
            SCNAction.sequence([
                SCNAction.run({(_)->()in chara.changeImage(aDirection:direction,aNum:0)}),
                SCNAction.wait(duration:duration*2/3),
                SCNAction.run({(_)->()in chara.changeImage(aDirection:direction,aNum:1)}),
                SCNAction.wait(duration:duration/3),
                ]))
    }
    //移動してくる場合
    func makeInMoveAction(x:CGFloat,y:CGFloat,z:CGFloat,duration:TimeInterval,chara:MapChara,direction:String)->
        (SCNAction,SCNAction){
            return (SCNAction.moveBy(x:x,y:y,z:z,duration:duration),
                    SCNAction.sequence([
                        SCNAction.wait(duration:duration/3),
                        SCNAction.run({(_)->()in chara.changeImage(aDirection:direction,aNum:2)}),
                        SCNAction.wait(duration:duration*2/3),
                        SCNAction.run({(_)->()in chara.changeImage(aDirection:direction,aNum:1)}),
                        ]))
    }
    //このマスにいるキャラが出て行くときのアニメーションを取得(直線移動の場合)
    func getOutAction(aDirection:String,aChara:MapChara)->(SCNAction,SCNAction){
        switch aDirection {
        case "up":return makeOutMoveAction(x:0,y:gTroutSizeCG*(mUpHeight-mCenterHeight),z:-gTroutSizeCG/2,
                                           duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "down":return makeOutMoveAction(x:0,y:gTroutSizeCG*(mDownHeight-mCenterHeight),z:gTroutSizeCG/2,
                                             duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "left":return makeOutMoveAction(x:-gTroutSizeCG/2,y:gTroutSizeCG*(mLeftHeight-mCenterHeight),z:0,
                                             duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "right":return makeOutMoveAction(x:gTroutSizeCG/2,y:gTroutSizeCG*(mRightHeight-mCenterHeight),z:0,
                                              duration:gMoveSpeed,chara:aChara,direction:aDirection)
        default:print("不正な方向→",aDirection)
        }
        return (SCNAction(),SCNAction())
    }
    //このマスにキャラが移動してくるときのアニメーションを取得(直線移動の場合)
    func getInAction(aDirection:String,aChara:MapChara)->(SCNAction,SCNAction){
        switch aDirection {
        case "up":return makeInMoveAction(x:0,y:-gTroutSizeCG*(mDownHeight-mCenterHeight),z:-gTroutSizeCG/2,
                                          duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "down":return makeInMoveAction(x:0,y:-gTroutSizeCG*(mUpHeight-mCenterHeight),z:gTroutSizeCG/2,
                                            duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "left":return makeInMoveAction(x:-gTroutSizeCG/2,y:-gTroutSizeCG*(mRightHeight-mCenterHeight),z:0,
                                            duration:gMoveSpeed,chara:aChara,direction:aDirection)
        case "right":return makeInMoveAction(x:gTroutSizeCG/2,y:-gTroutSizeCG*(mLeftHeight-mCenterHeight),z:0,
                                             duration:gMoveSpeed,chara:aChara,direction:aDirection)
        default:print("不正な方向→",aDirection)
        }
        return (SCNAction(),SCNAction())
    }
    ///////////////////////////////////////////
    //マスの高さ設定
    func setHeight(aDirection:String){
    }
}
