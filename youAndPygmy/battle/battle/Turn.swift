//
//  Turn.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class Turn{
    private static var mTurnChara:BattleChara!//行動中のキャラ
    //戦闘開始
    static func start(){
        nextTurn()
    }
    //次のキャラのターンへ
    static func nextTurn(){
        //勝敗判定
        if let tResult=Battle.judgeBattle(){
            Battle.end(aResult:tResult)
            return
        }
        //次に行動するキャラ決定
        mTurnChara=CharaManager.getNextTurnChara()
        //キャラの情報表示
        BattleDataUi.setTurnCharaData(aChara:mTurnChara)
        //行動させる
        if(mTurnChara.getAi() == .you){CharaController.toAct(aChara:mTurnChara,aEndFunction:nextTurn)}
        else{CharaAi.toAct(aChara:mTurnChara,aEndFunction:nextTurn)}
//        CharaController.toAct(aChara:mTurnChara,aEndFunction:nextTurn)
    }
}
