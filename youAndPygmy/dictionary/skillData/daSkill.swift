//
//  daSkill.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let zutuki=SkillData(
        name: "頭突き",
        details:"相手に頭から体当たりし攻撃する",
        category: .physics,
        type: .da,
        mp:0,
        counter:true,
        power:0,
        range:SkillRange(type:.adjacent),
        accuracy:100
    )
}
