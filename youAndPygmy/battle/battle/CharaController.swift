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
    private static var mMoveableTrouts:[BattleTrout]!
    //選択したスキル名
    private static var mSelectedSkillNum:Int?=nil
    //選択したスキルの攻撃可能範囲
    private static var mSkillRange:[BattleTrout]!
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
        //移動先として選択可能なマス
        mMoveableTrouts=[]
        for(tTrout,_) in mRoute{
            mMoveableTrouts.append(tTrout)
        }
        //スキルを表示
        CharaControlUi.setSkillBar(aChara:mTurnChara)
        //移動用ui表示
        CharaControlUi.showMoveUi(aMoveable:mMoveableTrouts)
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
        CharaControlUi.hide()
        mTurnChara.move(aRoute:tRoute,aEndFunction:{
            //スキル選択のui表示
            CharaControlUi.showSkillUi()
        })
    }
    //移動キャンセル(移動先選び直し)
    static func cancelMove(){
        //キャラを初期位置に戻す
        mTurnChara.move(aPosition:mStartPosition)
        //移動用ui表示
        CharaControlUi.showMoveUi(aMoveable:mMoveableTrouts)
    }
    //スキル選択
    static func tapSkillBar(aNum:Int){
        let tSkills=ActiveSkillUi.getSkills()
        if(!tSkills[aNum].1){
            //使用不可のスキルを選択した
            mSelectedSkillNum=nil
            return
        }
        //使用可能
        mSelectedSkillNum=aNum
        //攻撃範囲
        mSkillRange=SkillRangeSearcher.searchRange(aPosition:mTurnChara.getPosition(),aSkill:tSkills[aNum].0)
        //攻撃目標選択ui表示
        CharaControlUi.showTargetUi(aRange:mSkillRange,aSkill:tSkills[aNum].0,aChara:mTurnChara)
    }
    //攻撃する
    static func attack(){
        let tSelectedSkill=ActiveSkillUi.getSkills()[mSelectedSkillNum!].0
        let tSelectedSkillData=SkillDictionary.get(tSelectedSkill)
        //選択したマスが攻撃可能かどうか
        let tSelectedTrout=TroutTapMonitor.getSelectedTrout()
        if(tSelectedTrout==nil){return}//マスが選択されていない
        //選択したマスが攻撃範囲に含まれるか
        var tFlag=false
        for tTrout in mSkillRange!{
            if(tTrout !== tSelectedTrout!){continue}
            tFlag=true
            break
        }
        if(!tFlag){return}//攻撃不可能なマスを選択していた
        //選択したマスにいるキャラに攻撃できるか
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
        CharaControlUi.hide()
        //攻撃
        AttackOperator.attack(
            aChara:mTurnChara,
            aSkill:tSelectedSkill,
            aTargetTrout:tSelectedTrout!,
            aEndFunction:{()->()in
                //攻撃処理終了後の関数
                mEndFunction()
        })
    }
    //ターン終了
    static func endTurn(){
        CharaControlUi.hide()
        mEndFunction()
    }
}
