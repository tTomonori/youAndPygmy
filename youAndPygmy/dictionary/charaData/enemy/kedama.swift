//
//  kedama.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension EnemyDictionary{
    static let kedama=EnemyRaceData(
        raceKey:"kedama",
        raceName:"けだま",
        raceStatus:Status(
            hp:150,
            mp:20,
            atk:130,
            def:100,
            int:130,
            spt:100,
            dex:130,
            spd:130,
            pie:100
        ),
        mobility:Mobility(
            mov:4,
            grass:1,
            sand:1,
            water:-1,
            magma:-1,
            snow:1,
            ice:1,
            air:-1
        ),
        image:CharaImageData.init(
            body:["normal":"kedama"],
            eye:nil,
            mouth:nil
        ),
        skills:[
            (0,"zutuki"),
        ],
        natureSkill:nil,
        ai: .tonikakunaguru,
        strongType:[],
        weakType:[]
    )
}
