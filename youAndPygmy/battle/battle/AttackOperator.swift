//
//  AttackOperator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/11.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class AttackOperator{
    //攻撃する
    static func attack(aChara:BattleChara,aSkill:String,aTargetTrout:BattleTrout,
                       aEndFunction:@escaping ()->()){
        operateSkill(aChara:aChara,aSkill:aSkill,aTargetTrout:aTargetTrout,
                     aInvolvement:SkillRangeSearcher.searchInvolvement(aPosition:aChara.getPosition(),
                                                                       aTargetPosition:aTargetTrout.getPosition(),
                                                                       aSkill:aSkill),
                      aCounter:true,aEndFunction:aEndFunction)
    }
    //反撃する
    static func counter(aCounterAttacker:BattleChara,aDefender:BattleChara,aEndFunction:@escaping ()->()){
        if(aCounterAttacker.isDown()){//反撃するキャラが戦闘不能
            aEndFunction()
            return
        }
        let tDefenderPosition=aDefender.getPosition()
        if let tCounterSkill=aCounterAttacker.getCounterSkill(aPosition:tDefenderPosition){
            //反撃できる
            aCounterAttacker.displayCounter {
                //反撃表示後
                //巻き込み範囲
                let tInvolvement=SkillRangeSearcher.searchInvolvement(
                    aPosition:aCounterAttacker.getPosition(),aTargetPosition:tDefenderPosition,aSkill:tCounterSkill)
                //スキル効果処理
                operateSkill(aChara:aCounterAttacker,aSkill:tCounterSkill,aTargetTrout:Battle.getTrout(tDefenderPosition)!,
                             aInvolvement:tInvolvement,aCounter:false,aEndFunction:{()->()in
                                //反撃終了後
                                aEndFunction()
                })
            }
        }
        else{
            //反撃できない
            aEndFunction()
        }
    }
    //スキル効果処理
    static func operateSkill(aChara:BattleChara,aSkill:String,aTargetTrout:BattleTrout,aInvolvement:[BattleTrout],
                              aCounter:Bool,aEndFunction:@escaping ()->()){
        let tSkillData=SkillDictionary.get(aSkill)
        //スキル名アラート
        SkillAlert.displaySkillName(aName:tSkillData.name)
        //mp消費
        aChara.useMp(aMp:tSkillData.mp)
        let tTargetChara=aTargetTrout.getRidingChara()!//攻撃目標にされたキャラ
        //スキルを受けるキャラのリスト生成
        var tDamagedCharas:[BattleChara]=[]
        for tTrout in [aTargetTrout]+aInvolvement{
            if let tChara=tTrout.getRidingChara(){
                tDamagedCharas.append(tChara)
            }
        }
        switch tSkillData.category {
        case .physics:fallthrough//物理
        case .magic://魔法
            for i in 0..<tDamagedCharas.count{
                let tDefender=tDamagedCharas[i]
                let tDamage=DamageCalculator.calculateDamage(aAttacker:aChara,aDefender:tDefender,aSkill:aSkill)!
                RunLoop.main.add(//メインのrunloopに登録する
                    Timer.init(timeInterval:0.2*i,repeats:false,block:{(_)->()in
                        //ダメージor回避アニメーション終了後の処理
                        let tEndAnimateFunction={()->()in
                            if(i==tDamagedCharas.count-1){
                                //最後のキャラのダメージアニメーションが終わった
                                CharaManager.judgeDow(aEndFunction:{()->()in
                                    //戦闘不能判定
                                    if(aCounter){
                                        //反撃可能
                                        counter(aCounterAttacker:tTargetChara,aDefender:aChara,
                                                aEndFunction:aEndFunction)
                                    }
                                    else{
                                        //反撃不可
                                        aEndFunction()
                                    }
                                })
                            }
                        }
                        //ダメージのアニメーション
                        if(HitCalculator.hit(aAttacker:aChara,aDefender:tDefender,aSkill:aSkill)){
                        tDefender.addDamage(aDamage:tDamage,aEndFunction:{()->()in
                            tEndAnimateFunction()
                        })
                        }
                        else{//回避アニメーション
                            tDefender.displayAvoided {
                                tEndAnimateFunction()
                            }
                        }
                    })
                    , forMode: RunLoopMode.commonModes)
            }
        case .heal://回復
            for i in 0..<tDamagedCharas.count{
                let tDefender=tDamagedCharas[i]
                let tDamage=DamageCalculator.calculateDamage(aAttacker:aChara,aDefender:tDefender,aSkill:aSkill)!
                RunLoop.main.add(//メインのrunloopに登録する
                    Timer.init(timeInterval:0.2*i,repeats:false,block:{(_)->()in
                        //ダメージのアニメーション
                        tDefender.heal(aHeal:tDamage,aEndFunction:{()->()in
                            if(i==tDamagedCharas.count-1){
                                //最後のキャラのダメージアニメーションが終わった
                                aEndFunction()
                            }
                        })
                    })
                    , forMode: RunLoopMode.commonModes)
            }
//        case .assist://支援
//        case .disturbance://妨害
        default:print("アクティブスキルじゃないんだけど→",aSkill)
        }
    }
    //攻撃可能か判定(攻撃可能ならtrue)
    static func canAttack(aAttacker:BattleChara,aTargetTrout:BattleTrout,aSkill:String)->Bool{
        let tDefender=aTargetTrout.getRidingChara()
        if(tDefender==nil){return false}//誰もいないマスには攻撃できない
        let tSkillData=SkillDictionary.get(aSkill)
        //攻撃対象との関係
        switch tSkillData.category {
        case .physics:fallthrough//物理
        case .magic:fallthrough//魔法
        case .disturbance://妨害
            if(TeamRelationship.fellow.relative(aAttacker,tDefender!)){//味方には使えない
                return false
            }
        case .assist:fallthrough//支援
        case .heal://回復
            if(TeamRelationship.oponent.relative(aAttacker,tDefender!)){//敵には使えない
                return false
            }
        case .passive://パッシブ
            return false
        }
        //攻撃範囲内か
        let tRange=SkillRangeSearcher.searchRange(aPosition:aAttacker.getPosition(),aSkill:aSkill)
        for tTrout in tRange{
            if(tTrout === aTargetTrout){
                //攻撃範囲内だった
                return true
            }
        }
        return false
    }
}
