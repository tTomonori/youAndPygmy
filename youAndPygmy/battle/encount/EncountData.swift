//
//  EncountData.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/05.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

//エンカウント情報
struct EncountData{
    let encountGroup:Dictionary<Int,[(Int,Double)]>//[グループ番号:[ (フィールド初期化番号,当選確率) ]]
    //[フィールド初期化番号:(フィールド番号,[敵or味方:[キャラ初期配置]],[敵グループ番号])]
    let initialFeildData:Dictionary<Int,(Int,Dictionary<String,[BattlePosition]>,[Int])>
    let feild:Dictionary<Int,BattleFeildData>//[フィールド番号,フィールドデータ]
    let enemyGroup:Dictionary<Int,[(Int,Double)]>//[グループ番号:[ (敵番号,当選確率) ]]
    let enemy:Dictionary<Int,BattleEnemyData>
    
    //エンカウント番号を受け取り、初期化した戦闘データを返す
    func getInitializedBattleData(aNum:Int)->initializedBattleData{
        let tEncountGroup=encountGroup[aNum]!
        let tInitialFeildNum=retrieveRandomly(aList:tEncountGroup)
        let (tFeildNum,tInitialPosition,tEnemyGroupNumList)=initialFeildData[tInitialFeildNum]!
        
        var tEnemyData:[BattleEnemyData?]=[]
        for tEnemyGroupNum in tEnemyGroupNumList{
            let tEnemyNum=retrieveRandomly(aList:enemyGroup[tEnemyGroupNum]!)
            let tEnemy=(tEnemyNum == -1) ?nil:enemy[tEnemyNum]
            tEnemyData.append(tEnemy)
        }
        
        return initializedBattleData(
            battleFeildData:feild[tFeildNum]!,
            allyPosition:tInitialPosition["ally"]!,
            enemyPosition:tInitialPosition["enemy"]!,
            enemyData:tEnemyData
        )
    }
    //当選確率のリストからランダムに取り出す
    func retrieveRandomly(aList:[(Int,Double)])->Int{
        let tRandom:Double=Double(arc4random_uniform(1000)/10)
        for tData in aList{
            let (tElement,tProbability)=tData
            if(tProbability<tRandom){continue}
            return tElement
        }
        print("当選確率がおかしいよ",aList)
        return -1
    }
}
//バトルフィールドのデータ
struct BattleFeildData{
    let feild:[[Int]]
    let chip:Dictionary<Int,BattleChipData>
}
struct BattleChipData{
    let attribute:String//属性
    let terrain:String//地形名
}
//敵キャラのデータ
struct BattleEnemyData{
    let pygmyFlag:Bool//ぴぐみーor敵
    let raceKey:String//種族のキー
    let name:String?//キャラ名
    let level:Int//レベル
    let status:Status?//ステータス
    let mobility:Mobility?//移動力
    let currentHp:Int?//戦闘開始時のhp
    let skill:[String]//スキル
    let item:String//アイテム
    let itemNum:Int//持ち物の数
}
//初期化済みの戦闘データ
struct initializedBattleData{
    let battleFeildData:BattleFeildData
    let allyPosition:[BattlePosition]
    let enemyPosition:[BattlePosition]
    let enemyData:[BattleEnemyData?]
}
