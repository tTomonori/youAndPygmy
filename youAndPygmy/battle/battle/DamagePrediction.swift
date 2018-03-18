//
//  DamagePrediction.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/18.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class DamagePrediction{
    private static let mPredictionBox=BattleUiScene.getNode(aName:"predictionBox")!
    //攻撃予測
    private static let mAttackBox=mPredictionBox.childNode(withName:"attackPrediction")!
    //反撃予測
    private static let mCounterBox=mPredictionBox.childNode(withName:"counterPrediction")!
    //予測表示
    static func predict(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String){
        //攻撃予測
        var tDamage=DamageCalculator.calculateDamage(aAttacker:aAttacker,aDefender:aDefender,aSkill:aSkill)
        var tAccuracy=HitCalculator.calculateHit(aAttacker:aAttacker,aDefender:aDefender,aSkill:aSkill)
        var tSkillData=SkillDictionary.get(aSkill)
        //スキル名
        (mAttackBox.childNode(withName:"skillName") as! SKLabelNode).text=tSkillData.name
        //ダメージ
        (mAttackBox.childNode(withName:"damage")!.childNode(withName:"value") as! SKLabelNode).text
            = (tDamage==nil) ?"--":String(tDamage!)
        //命中率
        (mAttackBox.childNode(withName:"accuracy")!.childNode(withName:"value") as! SKLabelNode).text=String(tAccuracy)
        //回復orダメージの表記
        if(tSkillData.category == .heal){
            mAttackBox.childNode(withName:"damage")!.childNode(withName:"damageLabel")!.alpha=0
            mAttackBox.childNode(withName:"damage")!.childNode(withName:"healLabel")!.alpha=1
        }
        else{
            mAttackBox.childNode(withName:"damage")!.childNode(withName:"damageLabel")!.alpha=1
            mAttackBox.childNode(withName:"damage")!.childNode(withName:"healLabel")!.alpha=0
        }
        //反撃予測
        let tSkill=aDefender.getCounterSkill(aPosition:aAttacker.getPosition())
        if(tSkill != nil && aAttacker.getTeam() != aDefender.getTeam()){
            //反撃あり
            tSkillData=SkillDictionary.get(tSkill!)
            (mCounterBox.childNode(withName:"skillName") as! SKLabelNode).text=tSkillData.name
            tDamage=DamageCalculator.calculateDamage(aAttacker:aDefender,aDefender:aAttacker,aSkill:tSkill!)!
            tAccuracy=HitCalculator.calculateHit(aAttacker:aDefender,aDefender:aAttacker,aSkill:tSkill!)
            (mCounterBox.childNode(withName:"damage")!.childNode(withName:"value") as! SKLabelNode).text
                = (tDamage==nil) ?"--":String(tDamage!)
            (mCounterBox.childNode(withName:"accuracy")!.childNode(withName:"value") as! SKLabelNode).text=String(tAccuracy)
        }
        else{
            //反撃なし
            (mCounterBox.childNode(withName:"skillName") as! SKLabelNode).text="---"
            (mCounterBox.childNode(withName:"damage")!.childNode(withName:"value") as! SKLabelNode).text="--"
            (mCounterBox.childNode(withName:"accuracy")!.childNode(withName:"value") as! SKLabelNode).text="--"
        }
        mPredictionBox.alpha=1
    }
    //非表示
    static func hide(){
        mPredictionBox.alpha=0
    }
}
