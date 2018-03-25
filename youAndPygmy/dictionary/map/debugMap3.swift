//
//  debugMap3.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/04.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension MapDictionary{
    static let debug3=MapData(
        troutData:[
            0:[5:[1,1,1,1,1]
            ],
            1:[0:[2,2,2,2,2],
               1:[2,2,2,2,2],
               2:[1,2,2,1,1],
               3:[1,1,1,1,1],
               4:[1.12,1.12,1.12,1.12,1.12]
            ]
        ],
        chipData:[
            1:["canOn":true,"terrain":"grass"],
            2:["canOn":true,"terrain":"grass","object":"grass",
               "event":[
                    ["event":"encount","encountGroupNum":0]
                ]]
        ],
        npcData:[
            NpcData(name:"battleTestNpc",position:FeildPosition(x:1,y:1,z:4),imageName:"chara2",direction:"down",
                    speakEvents:[["event":"speak","sentence":"戦闘テストマップ"]])
        ],
        specialTrout:[
            ["position":FeildPosition(x:2,y:0,z:6),
             "chip":["terrain":"grass",
                     "shape":0.00,
                     "event":[
                        ["event":"changeMap","mapName":"debug","position":FeildPosition(x:4,y:1,z:0)],
                ]
                ]
            ]
        ],
        encountData:EncountData(
            encountGroup: [0:[(0,100)]],
            initialFeildData:[0:(0,[
                "ally":[
                    BattlePosition(x:0,y:2),
                    BattlePosition(x:1,y:2),
                    BattlePosition(x:2,y:2),
                    BattlePosition(x:3,y:2),
                    BattlePosition(x:4,y:2),
                ],
                "enemy":[
                    BattlePosition(x:0,y:0),
                    BattlePosition(x:1,y:0),
                ]
                ],[0,0])],
            feild:[0:BattleFeildData(
                feild:[[0,0,0,0,0,0,0,0],
                       [0,0,0,0,0,0,0,0],
                       [0,0,0,0,0,0,0,0]],
                chip:[0:TroutAttributeDictionary.get(key:"grass")]
                )],
            enemyGroup:[0:[(0,40),(1,50),(-1,10)]],
            enemy:[
                0:BattleEnemyData(
                    pygmyFlag: true,
                    raceKey: "myutansu",
                    name: nil,
                    level: 9,
                    status: nil,
                    mobility: nil,
                    currentHp: nil,
                    skill: ["sougeki","kyuuketu"],
                    item:nil,
                    itemNum: 0,
                    ai:nil
                ),
                1:BattleEnemyData(
                    pygmyFlag: false,
                    raceKey: "kedama",
                    name: nil,
                    level: 10,
                    status: nil,
                    mobility: nil,
                    currentHp: nil,
                    skill: ["zutuki"],
                    item:nil,
                    itemNum: 0,
                    ai:nil
                )
            ]
        )
    )
}
