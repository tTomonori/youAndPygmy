//
//  yukiusagi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/04/05.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension PygmyDictionary{
    static let yukiusagi=PygmyRaceData(
        raceKey:"yukiusagi",
        raceName:"ゆきうさぎ",
        raceStatus:Status(
            hp:200,
            mp:30,
            atk:140,
            def:100,
            ini:155,
            spt:110,
            dex:150,
            spd:160,
            pie:120
        ),
        mobility:Mobility(
            mov:4,
            grass:1,
            sand:2,
            water:-1,
            magma:-1,
            snow:1,
            ice:1,
            air:-1
        ),
        image:CharaImageData.init(
            body:["normal":"yukiusagi_body"],
            eye:["normal":"yukiusagi_eye","damage":"yukiusagi_eye_damage"],
            mouth:["normal":"yukiusagi_mouth","damage":"yukiusagi_mouth_damage"]
        ),
        skills:[
            (0,"tataku"),
            (5,"ziai"),
            (10,"konayuki")
        ],
        natureSkill:nil,
        ai: .tonikakunaguru,
        equipType:AccessoryType([])
    )
}
