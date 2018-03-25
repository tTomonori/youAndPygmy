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
        var tBattleData:[BattleCharaData?]=[]
        for tEnemyData in aData{
            if(tEnemyData==nil){tBattleData.append(nil);continue}
            //種族値取得
            let tRaceData=(tEnemyData!.pygmyFlag)
                ?PygmyDictionary.get(tEnemyData!.raceKey)
                :EnemyDictionary.get(tEnemyData!.raceKey)
            //ステータス計算
            let tStatus=(tEnemyData!.status==nil)
                ?StatusCalcurator.calcurate(aRaceStatus:tRaceData.raceStatus,aLevel:tEnemyData!.level)
                :StatusCalcurator.calcurate(aRaceStatus:tRaceData.raceStatus,aLevel:tEnemyData!.level)+tEnemyData!.status!
            //データ設定
            tBattleData.append(BattleCharaData(
                pygmyFlag: tEnemyData!.pygmyFlag,
                raceKey: tEnemyData!.raceKey,
                name: (tEnemyData!.name==nil) ?tRaceData.raceName:tEnemyData!.name!,
                level: tEnemyData!.level,
                status: tStatus,
                mobility: (tEnemyData!.mobility==nil)
                  ?tRaceData.mobility
                  :tEnemyData!.mobility!,
                currentHp:(tEnemyData!.currentHp==nil)
                  ?tStatus.hp
                  :(tStatus.hp<tEnemyData!.currentHp!) ?tStatus.hp:tEnemyData!.currentHp!,
                skill: tEnemyData!.skill,
                item: tEnemyData!.item,
                itemNum: tEnemyData!.itemNum,
                image:tRaceData.image,
                ai:(tEnemyData!.ai==nil) ?tRaceData.ai:tEnemyData!.ai!
            ))
        }
        return tBattleData
    }
    //味方の戦闘用データ生成
    static func buildAllyBattleData(aNum:Int)->[BattleCharaData?]{
        var tBattleData:[BattleCharaData?]=[]
        let tAccompanies=You.getBattleParticipants(aNum:aNum)
        for i in 0...aNum{
            if(tAccompanies.count<=i){tBattleData.append(nil);continue}
            let tPygmy=tAccompanies[i]
            let tRaceData=tPygmy.getRaceData()
            let (tItemKey,tItemNum)=tPygmy.getItem()
            tBattleData.append(BattleCharaData(
                pygmyFlag: true,
                raceKey: tRaceData.raceKey,
                name: tPygmy.getName(),
                level: tPygmy.getLevel(),
                status: tPygmy.getCorrectedStatus(),
                mobility: tPygmy.getCorrectedMobility(),
                currentHp: tPygmy.getCurrentHp()+tPygmy.getCorrection().hp,
                skill: tPygmy.getBattleSkills(),
                item: tItemKey,
                itemNum: tItemNum,
                image:tPygmy.getImage(),
                ai:.you
                )
            )
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
    let pygmyFlag:Bool//ぴぐみーor敵
    let raceKey:String//種族のキー
    let name:String//キャラ名
    let level:Int//レベル
    let status:Status//ステータス(全補正値込み)
    let mobility:Mobility//移動力
    let currentHp:Int//戦闘開始時のhp
    let skill:[String]//スキル
    let item:String?//アイテム
    let itemNum:Int//持ち物の数
    let image:CharaImageData//画像
    let ai:AiType//行動パターン
}
