//
//  healSkill.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/04/05.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let ziai=SkillData(
        name:"慈愛",
        details:"優しい光で相手を包み込み元気を回復させる",
        category:SkillCategory.heal,
        type:.sei,
        mp:2,
        counter:false,
        power:50,
        powerCorrectType:.multiplication,
        range:SkillRange(type:.range,range:3),
        accuracy:100
    )
}
