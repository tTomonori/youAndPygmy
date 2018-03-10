//
//  CharaController.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class CharaController{
    //行動するキャラ
    private static var mTurnChara:BattleChara!
    //ターン開始時にいた座標
    private static var mStartPosition:BattlePosition!
    //キャラの移動可能範囲とそこへの経路
    private static var mRoute:[(BattleTrout,[BattlePosition])]!
    //操作用ボタンのノード
    private static let mButton0=BattleUiScene.getNode(aName:"charaControlButton0")!
    private static let mButton1=BattleUiScene.getNode(aName:"charaControlButton1")!
    //操作用ボタンを押した時に実行する関数
    private static var mButtonFunction0:(()->())?=nil
    private static var mButtonFunction1:(()->())?=nil
    //使用可能なスキル表示ノード
    private static let mSkillBox=BattleUiScene.getNode(aName:"choiceSkillBox")!
    static func toAct(aChara:BattleChara){
        //行動するキャラ記憶
        mTurnChara=aChara
        //初期位置記憶
        mStartPosition=aChara.getPosition()
        //移動可能範囲を求める
        mRoute=RouteSearcher.search(aChara:aChara)
        //スキルを表示
        SkillBarMaker.setActiveSkill(aNode:mSkillBox,aSkills:aChara.getSkill())
        //移動用ui表示
        displayMoveUi()
        gGameViewController.allowUserOperate()
    }
    //移動先選択のui表示
    static func displayMoveUi(){
        changeRouteColor(aColor:UIColor(red:0,green:0,blue:1,alpha:0.4))
        mButtonFunction0={()->()in
            changeRouteColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
            displaySkillUi()
        }
        mButtonFunction1=decideMove
        mButton0.alpha=1
        mButton1.alpha=1
    }
    //移動先決定
    static func decideMove(){
        let tSelectedTrout=TroutTapMonitor.getSelectedTrout()
        if(tSelectedTrout==nil){return}//マスが選択されていない
        //移動可能なマスか判断
        var tRoute:[BattlePosition]=[]
        for (tTrout,tRoutData) in mRoute{
            if(tTrout !== tSelectedTrout!){continue}
            tRoute=tRoutData
            break
        }
        if(tRoute.count==0){return}//移動不可能なマスを選択していた
        //マスの色を戻す
        changeRouteColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        //ボタン非表示
        mButton0.alpha=0
        mButton1.alpha=0
        //キャラ移動
        mTurnChara.move(aRoute:tRoute,aEndFunction:{()->()in
            //移動終了時
            self.displaySkillUi()
        })
    }
    //スキル選択のui表示
    static func displaySkillUi(){
        mSkillBox.alpha=1
        mButtonFunction0={()->()in
            mSkillBox.alpha=0
            self.resetMove()
        }
        mButtonFunction1=nil
        mButton0.alpha=1
        mButton1.alpha=1
    }
    //移動キャンセル(移動先選び直し)
    static func resetMove(){
        mTurnChara.move(aPosition:mStartPosition)
        displayMoveUi()
    }
    //行動決定ボタン
    static func pushedButton0(){mButtonFunction0?()}
    static func pushedButton1(){mButtonFunction1?()}
    //スキル選択
    static func tapSkillBar(aNum:Int){
        let tRange=SkillRangeSearcher.search(aChara:mTurnChara,aSkill:mTurnChara.getSkill()[aNum])
        for (tTrout,_) in tRange{
            tTrout.changeColor(aColor:UIColor(red:1,green:0,blue:0,alpha:0.4))
        }
    }
    //移動可能なマスの色を変更
    static func changeRouteColor(aColor:UIColor){
        for (tTrout,_) in mRoute{
            tTrout.changeColor(aColor:aColor)
        }
    }
}
