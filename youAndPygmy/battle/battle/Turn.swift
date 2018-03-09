//
//  Turn.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class Turn{
    private static var mAllChara:[BattleChara]!//全てのキャラ
    private static var mAhead:[BattleChara]!//まだ行動していないキャラ
    private static var mTurnChara:BattleChara!//行動中のキャラ
    static func setCharas(aCharas:[BattleChara]){
        mAllChara=aCharas
        mAhead=[]
    }
    //戦闘開始
    static func start(){
        nextTurn()
    }
    //次のキャラのターンへ
    static func nextTurn(){
        //次に行動するキャラ決定
        sortAhead()
        mTurnChara=mAhead.removeFirst()
        //キャラの情報表示
        BattleDataUi.setTurnCharaData(aChara:mTurnChara)
        //行動させる
        if(mTurnChara.getAi() == .you){CharaController.toAct(aChara:mTurnChara)}
        else{CharaAi.toAct(aChara:mTurnChara)}
    }
    //まだ行動していないキャラを素早さ順にソート
    static func sortAhead(){
        if(mAhead.count==0){
            mAhead=mAllChara
            mAhead.sort(by: {
                ($0.getStatus(aStatus:"spd") == $1.getStatus(aStatus:"spd"))
                    //素早さが同じ
                    ?arc4random_uniform(1)==1
                    //素早さが異なる
                    :$0.getStatus(aStatus:"spd") > $1.getStatus(aStatus:"spd")
            })
        }
        else{
            mAhead.sort(by: {$0.getStatus(aStatus:"spd") >= $1.getStatus(aStatus:"spd")})
        }
    }
}
