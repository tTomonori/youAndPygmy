//
//  myutansu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension PygmyDictionary{
    static let myutansu=RaceData(
        raceKey:"myutansu",
        raceName:"みゅーたんす",
        raceStatus:Status(
            hp:180,
            mp:30,
            atk:170,
            def:95,
            int:170,
            spt:100,
            dex:155,
            spd:150,
            pie:105
        ),
        mobility:Mobility(
            mov:4,
            grass:1,
            sand:1,
            water:-1,
            magma:-1,
            snow:2,
            ice:2,
            air:-1
        ),
        image:CharaImageData.init(
            body:["normal":"myutansu_body"],
            eye:["normal":"myutansu_eye","damage":"myutansu_eye_damage"],
            mouth:["normal":"myutansu_mouth","damage":"myutansu_mouth_damage"]
        )
    )
}
