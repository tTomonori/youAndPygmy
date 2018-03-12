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
        Battle.judgeBattle()
        //次に行動するキャラ決定
        mTurnChara=CharaManager.getNextTurnChara()
        //キャラの情報表示
        BattleDataUi.setTurnCharaData(aChara:mTurnChara)
        //行動させる
//        if(mTurnChara.getAi() == .you){CharaController.toAct(aChara:mTurnChara)}
//        else{CharaAi.toAct(aChara:mTurnChara)}
        CharaController.toAct(aChara:mTurnChara)
    }
}
