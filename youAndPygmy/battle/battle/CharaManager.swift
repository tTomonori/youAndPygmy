//
//  CharaManager.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/12.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class CharaManager{
    //味方
    private static var mAllies:[BattleChara]!=nil
    //敵
    private static var mEnemies:[BattleChara]!=nil
    //生存しているキャラ
    private static var mSurvivingCharas:[BattleChara]!=nil
    //現在のターンに行動していないキャラ
    private static var mAhead:[BattleChara]!=nil
    //現在行動中のキャラ
    private static var mTurnChara:BattleChara!=nil
    //戦闘に参加するキャラセット
    static func set(aAllies:[BattleChara],aEnemies:[BattleChara]){
        mAllies=aAllies
        mEnemies=aEnemies
        mSurvivingCharas=mAllies+mEnemies
        mAhead=[]
    }
    //次に行動するキャラ取得
    static func getNextTurnChara()->BattleChara{
        //行動順更新
        sortAhead()
        //行動するキャラ決定
        mTurnChara=mAhead.removeFirst()
        return mTurnChara
    }
    //まだ行動していないキャラを素早さ順にソート
    static func sortAhead(){
        if(mAhead.count==0){
            //全員行動済み(or初回)
            mAhead=mSurvivingCharas
            mAhead.sort(by: {
                ($0.getStatus(aStatus:"spd") == $1.getStatus(aStatus:"spd"))
                    //素早さが同じ
                    ?arc4random_uniform(1)==1
                        //素早さが異なる
                    :$0.getStatus(aStatus:"spd") > $1.getStatus(aStatus:"spd")
            })
        }
        else{
            //まだ行動していないキャラがいる
            mAhead.sort(by: {$0.getStatus(aStatus:"spd") >= $1.getStatus(aStatus:"spd")})
        }
    }
    //戦闘不能判定
    static func judgeDow(){
        
    }
    //勝敗判定
    static func judgeBattle(){
        
    }
}
