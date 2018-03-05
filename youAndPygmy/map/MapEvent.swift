//
//  MapEvent.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class MapEvent{
    //主人公の正面のマスを調べる
    static func investigate(){
        //正面のマス
        let tFrontTrout=MapFeild.getNeighborTrout(aPosition:gPlayerChara.getPosition(),aDirection:gPlayerChara!.getDirection())
        if(tFrontTrout == nil){return}
        //正面のマスにいるキャラ
        let tOnChara=tFrontTrout!.getChara()
        if(tOnChara == nil){return}
        let tEvents=tOnChara!.getSpeakEvents()
        if(tEvents.count==0){return}
        MapUi.close()
        runEvents(aEvents:tEvents,aEndFunction:{()->()in
            MapUi.display()
            gGameViewController.allowUserOperate()
        })
    }
    //イベント処理
    static func runEvents(aEvents:[Dictionary<String,Any>],aEndFunction:@escaping ()->()){
        if(aEvents.count==0){aEndFunction();return}
        var tRun:(Int)->()={(_)->()in}
        tRun={(aIndex:Int)->()in
            if(aEvents.count<=aIndex){
                aEndFunction()
                return}//イベント処理全て終了
            let tEvent=aEvents[aIndex]
            var tEndFunction={()->()in tRun(aIndex+1)}
            if(tEvent["asyn"] != nil){//イベント同時実行
                tEndFunction={()->()in}
                tRun(aIndex+1)
            }
            //イベント処理
            switch tEvent["event"] as! String {
            case "speak"://会話文表示
                SpeakWindow.display(aSentence:tEvent["sentence"] as! String,aEndFunction:{()->()in
                    tEndFunction()
                })
            case "changeMap"://マップ移動
                SceneController.changeMap(aMapName:tEvent["mapName"] as! String, aPosition:tEvent["position"] as! FeildPosition,
                                          aEndFunction:{()->()in
                                            //マップ移動終了後
                                            tEndFunction()
                                            return
                })
            case "encount"://戦闘
                if(SaveData.countEncount()){
                    Encounter.encount(
                        aEncountData:MapFeild.getMapData().encountData,
                        aEncountNum:tEvent["encountGroupNum"] as! Int,
                        aEndFunction:{(aResult)->()in
                            MapFeild.display()
                            tEndFunction()
                    }
                    )
                }
                else{
                    tEndFunction()
                }
            default:print("不正なイベントを実行しようとしたぞ→",tEvent)
            }
        }
        tRun(0)
    }
}
