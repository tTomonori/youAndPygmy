//
//  SceneController.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SceneController{
    //アプリ起動
    static func didLoad(){
        Title.display()
        gGameViewController.allowUserOperate()
    }
    //ゲームスタート
    static func start(){
        //セーブデータ読み込み
        SaveData.load()
        //マップ設定
        MapFeild.setMap(aMapData:MapDictionary.get(aMapName:SaveData.getMapName()))
        //自キャラ配置
        MapFeild.setHero(aPosition:SaveData.getPosition())
        MapFeild.makeCameraFollowHero()
        MapFeild.display()
        MapUi.display()
        //ユーザデータ設定
        var tPygmies:[Pygmy]=[]
        for tData in SaveData.getAccompanying(){
            tPygmies.append(Pygmy(aData:tData))
        }
        You.setAccompanying(aAccompanying:tPygmies)
    }
    //メニューを開く
    static func openMainMenu(){
        MenuParent.display(aMenuName:"main", aClosedFunction:self.closedMenu)
    }
    //メニューが閉じられた
    static func closedMenu(){
        MapUi.display()
    }
    //マップ移動
    static func changeMap(aMapName:String,aPosition:FeildPosition,aEndFunction:@escaping ()->()){
        MapFeild.setMap(aMapData:MapDictionary.get(aMapName:aMapName))
        MapFeild.setHero(aPosition:aPosition)
        MapFeild.makeCameraFollowHero()
        SceneChanger.animateChangeMap(aChanging:{()->()in
            //画面全体が隠れた
            MapFeild.display()
        }, aChanged:{()->()in
            //アニメーション終了
            aEndFunction()
        })
    }
}
