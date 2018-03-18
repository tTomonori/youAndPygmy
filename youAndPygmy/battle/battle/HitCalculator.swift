//
//  HitCalculator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class HitCalculator{
    //当たり判定(当たったらtrue)
    static func hit(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String)->Bool{
        let tAccuracy=calculateHit(aAttacker:aAttacker,aDefender:aDefender,aSkill:aSkill)
        return Int(arc4random_uniform(99)+1) <= tAccuracy
    }
    //命中率を計算
    static func calculateHit(aAttacker:BattleChara,aDefender:BattleChara,aSkill:String)->Int{
        let tSpd=aDefender.getStatus(aStatus:"spd")
        let tDex=aAttacker.getStatus(aStatus:"dex")
        let tSkillData=SkillDictionary.get(aSkill)
        switch tSkillData.category {
        case .physics:fallthrough//物理
        case .magic:fallthrough//魔法
        case .disturbance://妨害
            var tAccuracy=tSkillData.accuracy+tDex-tSpd
            if(tAccuracy<5){tAccuracy=5}
            else if(tAccuracy>100){tAccuracy=100}
            return tAccuracy
        case .assist:fallthrough//支援
        case .heal://回復
            return tSkillData.accuracy
        case .passive://パッシブ
            return 100
        }
        
    }
}
