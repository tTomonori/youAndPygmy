//
//  iceSkill.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/04/05.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let konayuki=SkillData(
        name:"こなゆき",
        details:"粉雪を風で飛ばして攻撃する",
        category:SkillCategory.magic,
        type:.ice,
        mp:0,
        counter:false,
        power:0,
        powerCorrectType:.addition,
        range:SkillRange(type:.range,range:3),
        accuracy:95
    )
}
