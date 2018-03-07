//
//  EnemyData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class EnemyRaceData:RaceData{
    let strongType:[(SkillType,Int)]//(抵抗属性,減少量)
    let weakType:[(SkillType,Int)]//(弱点属性,増加量)
    init(
        raceKey:String,
        raceName:String,
        raceStatus:Status,
        mobility:Mobility,
        image:CharaImageData,
        skills:[(Int,String)],
        strongType:[(SkillType,Int)],
        weakType:[(SkillType,Int)]
        ){
        self.strongType=strongType
        self.weakType=weakType
        super.init(
            raceKey:raceKey,
            raceName:raceName,
            raceStatus:raceStatus,
            mobility:mobility,
            image:image,
            skills:skills
        )
    }
}
