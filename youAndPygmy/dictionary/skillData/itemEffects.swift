//
//  itemEffects.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/12.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension SkillDictionary{
    static let tiisanakinomi=SkillData(
        name: "小さなきのみ",
        details:"小さなきのみ　少しだけ回復する",
        category: .heal,
        type: .nature,
        mp: 0,
        counter: false,
        power: 0,
        range: SkillRange(type:.adjacentIncludeMyself),
        accuracy:100
    )
}
