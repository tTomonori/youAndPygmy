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
        if(aCounterAttacker.isDown()){//反撃するキャラが戦闘不能
            aEndFunction()
            return
        }
        let tSkills=aCounterAttacker.getSkill()
        let tDefenderTrout=Battle.getTrout(aPosition:aDefender.getPosition())!
        //反撃できるか確認
        for tSkill in tSkills{
            if(tSkill==""){continue}
            let tSkillData=SkillDictionary.get(tSkill)
            if(!tSkillData.counter){continue}//反撃不可スキル
            if(!aCounterAttacker.canUse(aSkill:tSkill)){continue}//スキルが使えない
            let tRange=SkillRangeSearcher.searchSkillRange(aPosition:aCounterAttacker.getPosition(),aSkill:tSkill)
            //攻撃範囲内に反撃する相手がいるかどうか
            for (tTrout,tInvolvement) in tRange{
                if(tDefenderTrout !== tTrout){continue}
                //反撃できる
                aCounterAttacker.displayCounter {
                    //反撃表示後
                    operateSkill(aChara:aCounterAttacker,aSkill:tSkill,aTargetTrout:tTrout,aInvolvement:tInvolvement,
                                 aCounter:false,aEndFunction:{()->()in
                                    //反撃終了後
                                    aEndFunction()
                    })
                }
                return
            }
            continue
        }
        //反撃できない
        aEndFunction()
    }
    //スキル効果処理
    static func operateSkill(aChara:BattleChara,aSkill:String,aTargetTrout:BattleTrout,aInvolvement:[BattleTrout],
                              aCounter:Bool,aEndFunction:@escaping ()->()){
        let tSkillData=SkillDictionary.get(aSkill)
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
}
