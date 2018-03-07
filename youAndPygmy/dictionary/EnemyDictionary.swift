//
//  EnemyDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class EnemyDictionary : NSObject{
    static func get(key:String)->EnemyRaceData{
        return self.value(forKey: key) as! EnemyRaceData
    }
}
