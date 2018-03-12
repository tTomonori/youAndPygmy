//
//  CharaAi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class CharaAi{
    //ターン終了時に呼ぶ関数
    private static var mEndFunction:(()->())!
    static func toAct(aChara:BattleChara,aEndFunction:@escaping ()->()){
        mEndFunction=aEndFunction
    }
}

enum AiType{
    case you
    case tonikakunaguru
}
