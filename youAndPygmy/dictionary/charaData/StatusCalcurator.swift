//
//  StatusCalcurator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/25.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class StatusCalcurator{
    //ステータス計算
    static func calcurate(aRaceStatus:Status,aLevel:Int,aPersonality:Status?)->Status{
        //個性値がnilなら全て0として扱う
        let tPersonality=(aPersonality != nil)
            ?aPersonality!
            :Status(hp:0,mp:0,atk:0,def:0,int:0,spt:0,dex:0,spd:0,pie:0)
        return Status(
            hp:(aRaceStatus.hp+tPersonality.hp*2)*(10+90*aLevel/100)/100,
            mp:(aLevel<50)
                ?(aRaceStatus.mp+tPersonality.mp)*(10+90*aLevel/50)/100
                :(aRaceStatus.mp+tPersonality.mp),
            atk:(aRaceStatus.atk+tPersonality.atk)*(5+95*aLevel/100)/100,
            def:(aRaceStatus.def+tPersonality.def)*(5+95*aLevel/100)/100,
            int:(aRaceStatus.int+tPersonality.int)*(5+95*aLevel/100)/100,
            spt:(aRaceStatus.spt+tPersonality.spt)*(5+95*aLevel/100)/100,
            dex:(aRaceStatus.dex+tPersonality.dex)*(5+95*aLevel/100)/100,
            spd:(aRaceStatus.spd+tPersonality.spd)*(5+95*aLevel/100)/100,
            pie:(aRaceStatus.pie+tPersonality.pie)*(5+95*aLevel/100)/100
        )
    }
}

struct Status{
    var hp:Int//元気
    var mp:Int//やる気
    var atk:Int//力強さ
    var def:Int//打強さ
    var int:Int//賢さ
    var spt:Int//聡明さ
    var dex:Int//器用さ
    var spd:Int//素早さ
    var pie:Int//優しさ
}
//Status(hp:0,mp:0,atk:0,def:0,int:0,spt:0,dex:0,spd:0,pie:0)
