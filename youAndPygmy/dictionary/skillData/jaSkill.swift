//
//  yamiSkill.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/28.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let kansen=SkillData(
        name:"感染",
        category:SkillCategory.magic,
        type:.ja,
        mp:5,
        counter:false,
        power:0,
        range:SkillRange(type:.circumference,range:1)
    )
}
