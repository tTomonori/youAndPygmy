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
        category:SkillCategory.physics,
        type:.totu,
        mp:0,
        counter:true,
        power:0,
        range:SkillRange(type:.line,range:2),
        accuracy:100
    )
    static let kyuuketu=SkillData(
        name:"吸血",
        category:SkillCategory.physics,
        type:.totu,
        mp:5,
        counter:false,
        power:0,
        range:SkillRange(type:.range,range:2),
        accuracy:95
    )
}
