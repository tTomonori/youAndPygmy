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
    private static var mSelectedSkill:String?=nil
    //選択したスキルの攻撃可能範囲
    private static var mSkillRange:[(BattleTrout,[BattleTrout])]?=nil
    //操作用ボタンのノード
    private static let mButton0=BattleUiScene.getNode(aName:"charaControlButton0")!
    private static let mButton1=BattleUiScene.getNode(aName:"charaControlButton1")!
    //操作用ボタンを押した時に実行する関数
    private static var mButtonFunction0:(()->())?=nil
    private static var mButtonFunction1:(()->())?=nil
    //使用可能なスキル表示ノード
    private static let mSkillBox=BattleUiScene.getNode(aName:"choiceSkillBox")!
    //使用可能なアイテム表示ノード
    private static let mItemBox=mSkillBox.childNode(withName:"itemBox")!
    static func toAct(aChara:BattleChara){
        //行動するキャラ記憶
        mTurnChara=aChara
        //初期位置記憶
        mStartPosition=aChara.getPosition()
        //移動可能範囲を求める
        mRoute=RouteSearcher.search(aChara:aChara)
        //スキルを表示
        setActiveSkillBar()
        //移動用ui表示
        displayMoveUi()
        gGameViewController.allowUserOperate()
    }
    //アクティブスキルをセット
    static func setActiveSkillBar(){
        let tSkills=mTurnChara.getSkill()
        SkillBarMaker.setActiveSkill(aNode:mSkillBox,aSkills:tSkills)
        for i in 0..<tSkills.count{
            let tSkill=tSkills[i]
            if(tSkill==""){continue}
            let tSkillData=SkillDictionary.get(key:tSkill)
            if(mTurnChara.getCurrentMp()<tSkillData.mp){
                //mpが足りない
                SkillBarMaker.blendBar(
                    aNode:mSkillBox.childNode(withName:"skill"+String(i))!,
                    aColor:UIColor(red:0,green:0,blue:0,alpha:0.4),
                    aBlend:1
                )
                
            }
        }
        //アイテム表示
        let tItem=mTurnChara.getItem()
        if(tItem.0 != ""){
            let tItemEffect=SkillDictionary.get(key:(ItemDictionary.get(key:tItem.0).effectKey))
            if(tItemEffect.category != .passive){
                ItemBarMaker.setItemLabel(aNode:mItemBox,aItem:mTurnChara.getItem())
            }
            else{
                mItemBox.alpha=0
            }
        }
        else{
            mItemBox.alpha=0
        }
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
            changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
            mSkillRange=nil
            self.resetMove()
        }
        mButtonFunction1=attack
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
        changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        mSelectedSkill=mTurnChara.getSkill()[aNum]
        mSkillRange=SkillRangeSearcher.searchSkillRange(aChara:mTurnChara,aSkill:mSelectedSkill!)
        changeRangeColor(aColor:UIColor(red:1,green:0,blue:0,alpha:0.4))
    }
    //アイテム選択
    static func tapItemBar(){
        changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        let (tItemKey,_)=mTurnChara.getItem()
        mSelectedSkill=ItemDictionary.get(key:tItemKey).effectKey
        mSkillRange=SkillRangeSearcher.searchSkillRange(aChara:mTurnChara,aSkill:mSelectedSkill!)
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
        if(mSelectedSkill==nil){return}
        let tSelectedSkillData=SkillDictionary.get(key:mSelectedSkill!)
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
        let tSelectedSkill=mSelectedSkill!
        changeRangeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        mSelectedSkill=nil
        mSkillRange=nil
        mSkillBox.alpha=0
        mButton0.alpha=0
        mButton1.alpha=0
        //攻撃
        AttackOperator.attack(
            aChara:mTurnChara,
            aSkill:tSelectedSkill,
            aTargetTrout:tSelectedTrout!,
            aInvolvement:tInvolvement!,
            aEndFunction:{()->()in
                //攻撃処理終了後の関数
                Turn.nextTurn()
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
