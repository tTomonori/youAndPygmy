//
//  DamageCalculator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/10.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class DamageCalculator{
    //火力計算
    static func calculateBurst(aChara:BattleChara,aSkill:String)->Int?{
        let tSkillData=SkillDictionary.get(key:aSkill)
        switch tSkillData.category {
        case .physics:
            return aChara.getStatus(aStatus:"atk")+tSkillData.power
        case .magic:
            return aChara.getStatus(aStatus:"ini")+tSkillData.power
        default:return nil
        }
    }
    //ダメージ計算
    static func calculateDamage(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String)->Int?{
        let tSkillData=SkillDictionary.get(key:aSkill)
        switch tSkillData.category {
        case .physics://物理
            let tBurst=calculateBurst(aChara:aAttacker,aSkill:aSkill)!
            let tDamage=tBurst-aDefender.getStatus(aStatus:"def")
            return (tDamage<1) ?1:tDamage
        case .magic://魔法
            let tBurst=calculateBurst(aChara:aAttacker,aSkill:aSkill)!
            let tDamage=tBurst-aDefender.getStatus(aStatus:"spt")
            return (tDamage<1) ?1:tDamage
        case .heal://回復
            return (aAttacker.getStatus(aStatus:"pie")+aDefender.getStatus(aStatus:"pie"))/2+tSkillData.power
        default:return nil
        }
    }
}
