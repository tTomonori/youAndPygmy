//
//  PygmyDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/24.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class PygmyDictionary : NSObject{
    static func get(_ key:String)->PygmyRaceData{
        return self.value(forKey: key) as! PygmyRaceData
    }
}
