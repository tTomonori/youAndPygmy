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
    //選択したスキル名
    private static var mSelectedSkillNum:Int?=nil
    //選択したスキルの攻撃可能範囲
    private static var mSkillRange:[(BattleTrout,[BattleTrout])]?=nil
    //操作用ボタンのノード
    private static let mButton0=BattleUiScene.getNode(aName:"charaControlButton0")!
    private static let mButton1=BattleUiScene.getNode(aName:"charaControlButton1")!
    private static let mButton2=BattleUiScene.getNode(aName:"charaControlButton2")!
    //操作用ボタンを押した時に実行する関数
    private static var mButtonFunction0:(()->())?=nil
    private static var mButtonFunction1:(()->())?=nil
    private static var mButtonFunction2:(()->())?=nil
    //ターン終了時に呼ぶ関数
    private static var mEndFunction:(()->())!
    static func toAct(aChara:BattleChara,aEndFunction:@escaping ()->()){
        mEndFunction=aEndFunction
        //行動するキャラ記憶
        mTurnChara=aChara
        //初期位置記憶
        mStartPosition=aChara.getPosition()
        //移動可能範囲を求める
        mRoute=RouteSearcher.search(aChara:aChara)
        //スキルを表示
        ActiveSkillUi.set(aChara:mTurnChara)
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
        mButtonFunction2={()->()in
            changeRouteColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
            mButton0.alpha=0
            mButton1.alpha=0
            mButton2.alpha=0
            mEndFunction()
        }
        mButton0.alpha=1
        mButton1.alpha=1
        mButton2.alpha=1
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
        mButton2.alpha=0
        //キャラ移動
        mTurnChara.move(aRoute:tRoute,aEndFunction:{()->()in
            //移動終了時
            self.displaySkillUi()
        })
    }
    //スキル選択のui表示
    static func displaySkillUi(){
        ActiveSkillUi.display()
        mButtonFunction0={()->()in
            ActiveSkillUi.hide()
            changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
            mSelectedSkillNum=nil
            mSkillRange=nil
            self.resetMove()
        }
        mButtonFunction1=attack
        mButtonFunction2={()->()in
            ActiveSkillUi.hide()
            changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
            mSelectedSkillNum=nil
            mSkillRange=nil
            mButton0.alpha=0
            mButton1.alpha=0
            mButton2.alpha=0
            mEndFunction()
        }
        mButton0.alpha=1
        mButton1.alpha=1
        mButton2.alpha=1
    }
    //移動キャンセル(移動先選び直し)
    static func resetMove(){
        mTurnChara.move(aPosition:mStartPosition)
        displayMoveUi()
    }
    //行動決定ボタン
    static func pushedButton0(){mButtonFunction0?()}
    static func pushedButton1(){mButtonFunction1?()}
    static func pushedButton2(){mButtonFunction2?()}
    //スキル選択
    static func tapSkillBar(aNum:Int){
        changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        let tSkills=ActiveSkillUi.getSkills()
        if(!tSkills[aNum].1){
            //使用不可のスキルを選択した
            mSelectedSkillNum=nil
            return
        }
        mSelectedSkillNum=aNum
        mSkillRange=SkillRangeSearcher.searchSkillRange(aChara:mTurnChara,aSkill:tSkills[aNum].0)
        changeRangeColor(aColor:UIColor(red:1,green:0,blue:0,alpha:0.4))
    }
    //移動可能なマスの色を変更
    static func changeRouteColor(aColor:UIColor){
        for (tTrout,_) in mRoute{
            tTrout.changeColor(aColor:aColor)
        }
    }
    //攻撃する
    static func attack(){
        //スキルが選択されていない
        if(mSelectedSkillNum==nil){return}
        let tSelectedSkill=ActiveSkillUi.getSkills()[mSelectedSkillNum!].0
        let tSelectedSkillData=SkillDictionary.get(key:tSelectedSkill)
        //選択したマスが攻撃可能かどうか
        let tSelectedTrout=TroutTapMonitor.getSelectedTrout()
        if(tSelectedTrout==nil){return}//マスが選択されていない
        //巻き込み範囲取得
        var tInvolvement:[BattleTrout]?=nil
        for (tTrout,tInvolvementData) in mSkillRange!{
            if(tTrout !== tSelectedTrout!){continue}
            tInvolvement=tInvolvementData
            break
        }
        if(tInvolvement==nil){return}//攻撃不可能なマスを選択していた
        if let tTargetChara=tSelectedTrout!.getRidingChara(){
            let tCategory=tSelectedSkillData.category
            //攻撃,妨害スキルで味方を選択
            if(tCategory == .physics || tCategory == .magic || tCategory == .disturbance){
                if(mTurnChara.getTeam()==tTargetChara.getTeam()){return}
            }
            //回復,支援スキルで敵を選択
            if(tCategory == .heal || tCategory == .assist){
                if(mTurnChara.getTeam() != tTargetChara.getTeam()){return}
            }
        }
        else{return}//誰もいないマスを選択していた
        //攻撃可能
        //アイテム消費
        if(mSelectedSkillNum==4){mTurnChara.useItem()}
        changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        mSelectedSkillNum=nil
        mSkillRange=nil
        ActiveSkillUi.hide()
        mButton0.alpha=0
        mButton1.alpha=0
        mButton2.alpha=0
        //攻撃
        AttackOperator.attack(
            aChara:mTurnChara,
            aSkill:tSelectedSkill,
            aTargetTrout:tSelectedTrout!,
            aInvolvement:tInvolvement!,
            aEndFunction:{()->()in
                //攻撃処理終了後の関数
                mEndFunction()
        })
    }
    //スキルの攻撃可能な範囲の色を変更
    static func changeRangeColor(aColor:UIColor){
        if(mSkillRange==nil){return}
        for (tTrout,_) in mSkillRange!{
            tTrout.changeColor(aColor:aColor)
        }
    }
}
