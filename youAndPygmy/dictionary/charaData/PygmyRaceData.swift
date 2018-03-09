//
//  PygmyData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class PygmyRaceData:RaceData{
    let equipType:[AccessoryType]//装備タイプ
    init(
        raceKey:String,
        raceName:String,
        raceStatus:Status,
        mobility:Mobility,
        image:CharaImageData,
        skills:[(Int,String)],
        ai:AiType,
        equipType:[AccessoryType]
        ){
        self.equipType=equipType
        super.init(
            raceKey:raceKey,
            raceName:raceName,
            raceStatus:raceStatus,
            mobility:mobility,
            image:image,
            skills:skills,
            ai:ai
        )
    }
}
