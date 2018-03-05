//
//  Encounter.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/05.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class Encounter{
    static func encount(aEncountData:EncountData,aEncountNum:Int,aEndFunction:@escaping (String)->()){
        let tInitializedBattleData=aEncountData.getInitializedBattleData(aNum:aEncountNum)
        
        let tBattleData=BattleData(
            feild: tInitializedBattleData.battleFeildData,
            winCondition: "extinction",
            loseCondition: "extinction",
            allyPosition: tInitializedBattleData.allyPosition,
            allies: buildAllyBattleData(aNum:tInitializedBattleData.allyPosition.count),
            enemyPosition: tInitializedBattleData.enemyPosition,
            enemies: convertEnemyData(aData:tInitializedBattleData.enemyData)
        )
        //戦闘情報セット
        Battle.setBattle(aBattleData:tBattleData)
        //シーン変更
        SceneController.enterBattle(aEndFunction:{()->()in
            //シーン変更完了
            Battle.start(aEndFunction:{(aResult)->()in
                //戦闘終了
                aEndFunction(aResult)
            })
        })
    }
    //敵の情報を戦闘用のデータに変換
    static func convertEnemyData(aData:[BattleEnemyData?])->[BattleCharaData?]{
        let tBattleData:[BattleCharaData?]=[]
        for tEnemyData in aData{
            
        }
        return tBattleData
    }
    //味方の戦闘用データ生成
    static func buildAllyBattleData(aNum:Int)->[BattleCharaData?]{
        let tBattleData:[BattleCharaData?]=[]
        let tAccompanies=You.getAccompanying()
        for tNum in 0...aNum{
            
        }
        return tBattleData
    }
}

//Battleクラスに渡す戦闘データ
struct BattleData{
    let feild:BattleFeildData
    let winCondition:String
    let loseCondition:String
    //味方情報
    let allyPosition:[BattlePosition]
    let allies:[BattleCharaData?]
    //敵情報
    let enemyPosition:[BattlePosition]
    let enemies:[BattleCharaData?]
}

//戦闘用のキャラデータ
struct BattleCharaData{
    
}
