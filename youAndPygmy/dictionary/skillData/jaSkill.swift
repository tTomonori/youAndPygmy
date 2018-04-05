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
        details:"周りの相手を病原体に感染させ攻撃する(状態異常を付与したい)",
        category:SkillCategory.magic,
        type:.ja,
        mp:5,
        counter:false,
        power:50,
        powerCorrectType:.multiplication,
        range:SkillRange(type:.circumference,range:1),
        accuracy:90
    )
}
