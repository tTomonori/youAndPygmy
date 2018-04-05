//
//  totuSkill.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let sougeki=SkillData(
        name:"槍撃",
        details:"槍で相手を貫いて攻撃する",
        category:SkillCategory.physics,
        type:.totu,
        mp:0,
        counter:true,
        power:0,
        powerCorrectType:.addition,
        range:SkillRange(type:.line,range:2),
        accuracy:100
    )
    static let kyuuketu=SkillData(
        name:"吸血",
        details:"相手の生命力を吸収して攻撃する(攻撃後に回復するようにしたい)",
        category:SkillCategory.physics,
        type:.totu,
        mp:5,
        counter:false,
        power:0,
        powerCorrectType:.addition,
        range:SkillRange(type:.range,range:2),
        accuracy:95
    )
}
