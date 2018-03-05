//
//  debugMap2.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/22.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

extension MapDictionary{
    static let debug2=MapData(
        troutData:[
            0:[0:[1,1,1,1],
               1:[1,1,1,1,1],
               2:[1,1,1,1]
            ],
            1:[ 1:[0,0,0,0,1.13,1.00]
            ],
            2:[ 0:[0,0,0,0,0.00,1.12]
            ],
            3:[-2:[0,0,0,0,1.00,1.00],
               -1:[0,0,0,0,0.00,1.12]
            ],
            4:[-5:[1,1,1],
               -4:[1,1,1],
               -3:[1,1,1],
               -2:[1,1,1,1.14]
            ]
        ],
        chipData:[
            1:["terrain":"grass"]
        ],
        npcData:[],
        specialTrout:[
            ["position":FeildPosition(x:-1,y:0,z:1),
             "chip":["terrain":"grass",
                     "shape":0.00,
                     "event":[
                              ["event":"changeMap","mapName":"debug","position":FeildPosition(x:7,y:1,z:4)],
                            ]
                ]
            ]
        ],
        encountData:nil
    )
}
