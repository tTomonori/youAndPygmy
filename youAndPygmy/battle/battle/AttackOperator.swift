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
    static func attack(aChara:BattleChara,aSkill:String,aTargetTrout:BattleTrout,aInvolvement:[BattleTrout],
                       aEndFunction:@escaping ()->()){
        operateSkill(aChara:aChara,aSkill:aSkill,aTargetTrout:aTargetTrout,aInvolvement:aInvolvement,
                      aCounter:true,aEndFunction:aEndFunction)
    }
    //反撃する
    static func counter(aCounterAttacker:BattleChara,aDefender:BattleChara,aEndFunction:@escaping ()->()){
        aEndFunction()
    }
    //スキル効果処理
    static func operateSkill(aChara:BattleChara,aSkill:String,aTargetTrout:BattleTrout,aInvolvement:[BattleTrout],
                              aCounter:Bool,aEndFunction:@escaping ()->()){
        let tSkillData=SkillDictionary.get(key:aSkill)
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
                Timer.scheduledTimer(withTimeInterval:0.2*i,repeats:false,block:{(_)->()in
                    //ダメージのアニメーション
                    tDefender.addDamage(aDamage:tDamage,aEndFunction:{()->()in
                        if(i==tDamagedCharas.count-1){
                            //最後のキャラのダメージアニメーションが終わった
                            CharaManager.judgeDow()//戦闘不能判定
                            if(aCounter){
                                //反撃可能
                                counter(aCounterAttacker:tTargetChara,aDefender:aChara,
                                        aEndFunction:aEndFunction)
                            }
                            else{
                                //反撃不可
                                aEndFunction()
                            }
                        }
                    })
                })
            }
        case .heal://回復
            for i in 0..<tDamagedCharas.count{
                let tDefender=tDamagedCharas[i]
                let tDamage=DamageCalculator.calculateDamage(aAttacker:aChara,aDefender:tDefender,aSkill:aSkill)!
                Timer.scheduledTimer(withTimeInterval:0.2*i,repeats:false,block:{(_)->()in
                    //ダメージのアニメーション
                    tDefender.heal(aHeal:tDamage,aEndFunction:{()->()in
                        if(i==tDamagedCharas.count-1){
                            //最後のキャラのダメージアニメーションが終わった
                            aEndFunction()
                        }
                    })
                })
            }
//        case .assist://支援
//        case .disturbance://妨害
        default:print("アクティブスキルじゃないんだけど→",aSkill)
        }
    }
}
