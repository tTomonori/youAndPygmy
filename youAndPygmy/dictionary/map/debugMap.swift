//
//  debugMap.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension MapDictionary{
    static let debug=MapData(
        troutData:[
            0:[0:[1,1,1,1,1,1,1,1],
               1:[1,1,1,1,1,1,1,1],
               2:[1,1,1,1,1,1,1,1],
               3:[1,1,1,2,2,1,1,1],
               4:[1,1,1,2,2,1,1,1],
               5:[1,1,1,1,1,1,1,1],
               6:[1,1,1,1,1,1,1,1],
                ],
            1:[0:[1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00],
               1:[1.00,1.00,1.12,1.12,1.12,1.12,1.00,1.00],
               2:[1.00,1.14,0.00,0.00,0.00,0.00,1.13,1.00],
               3:[1.00,1.14,0.00,0.00,0.00,0.00,1.13,1.00],
               4:[1.00,1.14,0.00,0.00,0.00,0.00,1.13,1.00],
               5:[1.00,0.00,0.00,0.00,0.00,0.00,0.00,1.00],
               ],
            2:[
                5:[1.11,0.00,0.00,0.00,0.00,0.00,0.00,1.11],
                6:[1,1,1,1,1,1,1,1],
            ]
        ],
        chipData:[
            1:["canOn":true,"terrain":"grass"],
            2:["canOn":false,"terrain":"water"],
        ],
        npcData:[
            NpcData(name:"test",position:FeildPosition(x:3,y:1,z:0),imageName:"chara2",direction:"down",speakEvents:[]),
            NpcData(name:"test2",position:FeildPosition(x:5,y:1,z:0),imageName:"chara2",direction:"left",
                    speakEvents:[["event":"speak","sentence":"テスト"]])
        ],
        specialTrout:[
            ["position":FeildPosition(x:8,y:1,z:4),
             "chip":["terrain":"grass",
                     "shape":0.00,
                     "event":[
                        ["event":"changeMap","mapName":"debug2","position":FeildPosition(x:0,y:0,z:1)],
//                        ["event":"speak","sentence":"マップ移動"],
                        ]
                ]
            ],
            ["position":FeildPosition(x:4,y:1,z:-1),
             "chip":["terrain":"grass",
                     "shape":0.00,
                     "event":[
                        
                        ["event":"changeMap","mapName":"debug3","position":FeildPosition(x:2,y:0,z:5)],
                ]
                ]
            ]
        ],
        encountData:nil
    )
}
