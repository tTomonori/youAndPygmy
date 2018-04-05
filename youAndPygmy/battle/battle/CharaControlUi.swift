//
//  CharaControlUi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/20.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class CharaControlUi{
    //変色したマス
    private static var mMarkedTrouts:[BattleTrout]=[]
    //操作用ボタンのノード
    private static let mButton0=BattleUiScene.getNode(aName:"charaControlButton0")!
    private static let mButton1=BattleUiScene.getNode(aName:"charaControlButton1")!
    private static let mButton2=BattleUiScene.getNode(aName:"charaControlButton2")!
    //操作用ボタンを押した時に実行する関数
    private static var mButtonFunction0:(()->())?=nil
    private static var mButtonFunction1:(()->())?=nil
    private static var mButtonFunction2:(()->())?=nil
    //行動決定ボタンの関数
    static func pushedButton0(){mButtonFunction0?()}
    static func pushedButton1(){mButtonFunction1?()}
    static func pushedButton2(){mButtonFunction2?()}
    //スキルバーセット
    static func setSkillBar(aChara:BattleChara){
        ActiveSkillUi.set(aChara:aChara)
    }
    //移動先選択ui
    static func showMoveUi(aMoveable:[BattleTrout]){
        hide()
        mMarkedTrouts=aMoveable
        changeTroutsColor(aColor:UIColor(red:0,green:0,blue:1,alpha:0.4))//マスの色を変える
        //移動先決定ボタン
        mButtonFunction0={()->()in
            CharaController.decideMove()
        }
        //スキル選択ボタン
        mButtonFunction1={()->()in
            showSkillUi()
        }
        //ターン終了ボタン
        mButtonFunction2={()->()in
            //確認ウィンドウ表示
            ChoiceDisplayer.confirme(aText:"ターンを終えてもいい？", aAnser:{(aAnser)->()in
                if(!aAnser){return}
                CharaController.endTurn()
            })
        }
        //ボタン表示
        mButton0.alpha=1
        mButton1.alpha=1
        mButton2.alpha=1
    }
    //スキル選択ui
    static func showSkillUi(){
        hide()
        //スキルバー表示
        ActiveSkillUi.display()
        //移動キャンセルボタン
        mButtonFunction1={()->()in
            CharaController.cancelMove()
        }
        //ターン終了ボタン
        mButtonFunction2={()->()in
            //確認ウィンドウ表示
            ChoiceDisplayer.confirme(aText:"ターンを終えてもいい？", aAnser:{(aAnser)->()in
                if(!aAnser){return}
                CharaController.endTurn()
            })
        }
        mButton1.alpha=1
        mButton2.alpha=1
    }
    //攻撃目標選択ui
    static func showTargetUi(aRange:[BattleTrout],aSkill:String,aChara:BattleChara){
        hide()
        mMarkedTrouts=aRange
        let tSkillData=SkillDictionary.get(aSkill)
        let tMasColor:UIColor=(tSkillData.category == .heal)
            ?UIColor(red:0,green:1,blue:0,alpha:0.4)
            :UIColor(red:1,green:0,blue:0,alpha:0.4)
        changeTroutsColor(aColor:tMasColor)//マスの色を変える
        //攻撃目標決定ボタン
        mButtonFunction0={()->()in
            CharaController.attack()
        }
        //スキル選び直しボタン
        mButtonFunction1={()->()in
            showSkillUi()
        }
        //移動キャンセルボタン
        mButtonFunction2={()->()in
            CharaController.cancelMove()
        }
        //ダメージ予測
        TroutTapMonitor.setTappedFunction(aFunction:{(aTrout)->()in
            if(AttackOperator.canAttack(aAttacker:aChara,aTargetTrout:aTrout,aSkill:aSkill)){
                //攻撃可能なマス
                let tTargetChara=aTrout.getRidingChara()
                DamagePrediction.predict(aAttacker:aChara,aDefender:tTargetChara!,aSkill:aSkill)
            }
            else{
                //攻撃不可能なマス
                DamagePrediction.hide()
            }
        })
        //ボタン表示
        mButton0.alpha=1
        mButton1.alpha=1
        mButton2.alpha=1
    }
    //全部隠す
    static func hide(){
        //マスの色を戻す
        resetTroutsColor()
        mMarkedTrouts=[]
        //スキルバーを隠す
        ActiveSkillUi.hide()
        //ダメージ予測を隠す
        DamagePrediction.hide()
        TroutTapMonitor.setTappedFunction(aFunction:nil)
        //ボタンを隠す
        mButton0.alpha=0
        mButton1.alpha=0
        mButton2.alpha=0
    }
    //マスの色を変更
    static func changeTroutsColor(aColor:UIColor){
        for tTrout in mMarkedTrouts{
            tTrout.changeColor(aColor:aColor)
        }
    }
    //マスの色を戻す
    static func resetTroutsColor(){
        for tTrout in mMarkedTrouts{
            tTrout.changeColor(aColor:UIColor(red:0,green:0,blue:0,alpha:0))
        }
    }
}
