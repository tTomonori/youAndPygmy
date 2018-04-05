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
        let tSkillData=SkillDictionary.get(aSkill)
        let tOffensive:Int//攻撃力
        var tBurst:Int//火力
        //攻撃属性
        switch tSkillData.category {
        case .physics:
            tOffensive=aChara.getStatus(aStatus:"atk")
        case .magic:
            tOffensive=aChara.getStatus(aStatus:"ini")
        default:return nil
        }
        //倍率
        switch tSkillData.powerCorrectType! {
        case .addition://加算
            tBurst=tOffensive+tSkillData.power
        case .multiplication://乗算
            tBurst=Int((tSkillData.power/100.0)*tOffensive)
        case .constant://固定
            tBurst=tSkillData.power
        }
        return tBurst
    }
    //ダメージ計算
    static func calculateDamage(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String)->Int?{
        let tSkillData=SkillDictionary.get(aSkill)
        let tDeffense:Int//防御力
        //攻撃属性
        switch tSkillData.category {
        case .physics://物理
            tDeffense=aDefender.getStatus(aStatus:"def")
        case .magic://魔法
            tDeffense=aDefender.getStatus(aStatus:"spt")
        case .heal://回復
            return calculateHeal(aAttacker:aAttacker,aDefender:aDefender,aSkill:aSkill)
        default:return nil
        }
        //火力
        let tBurst=calculateBurst(aChara:aAttacker,aSkill:aSkill)!
        //ダメージ
        var tDamage=tBurst-tDeffense
        if(tDamage<1){tDamage=1}
        return tDamage
    }
    //回復量計算
    static func calculateHeal(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String)->Int?{
        let tSkillData=SkillDictionary.get(aSkill)
        //回復力
        let tResilience:Int=(aAttacker.getStatus(aStatus:"pie")+aDefender.getStatus(aStatus:"pie"))/2
        //回復倍率
        var tHeal:Int
        //倍率
        switch tSkillData.powerCorrectType! {
        case .addition://加算
            tHeal=tResilience+tSkillData.power
        case .multiplication://乗算
            tHeal=Int((tSkillData.power/100.0)*tResilience)
        case .constant://固定
            tHeal=tSkillData.power
        }
        return tHeal
    }
}
