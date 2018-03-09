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
}
