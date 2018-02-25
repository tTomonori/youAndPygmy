//
//  MapTroutMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class MapTroutMaker{
    //マップチップのデータ表
    static var mMapChip:Dictionary<Int,Dictionary<String,Any>>!
    //マップチップのデータ表をセット
    static func setMapChip(aData:Dictionary<Int,Dictionary<String,Any>>){
        mMapChip=aData
    }
    //マスを生成(データ表を使用)
    static func makeTrout(aChipNum:Float,aPosition:FeildPosition)->MapTrout{
        //ノード生成
        let tTrout=makeShape(aNum:aChipNum)
        //チップ取得
        let tChip=mMapChip[Int(aChipNum)]!
        //マスに情報セット
        tTrout.setChip(aChip:tChip)
        tTrout.setPosition(aPosition:FeildPosition(x:aPosition.x,y:aPosition.y,z:aPosition.z))
        return tTrout
    }
    //マスを生成(引数でチップを指定)
    static func makeTroutWithChipData(aPosition:FeildPosition,aChip:Dictionary<String,Any>)->MapTrout{
        //ノード生成
        let tTrout=makeShape(aNum:Float(aChip["shape"] as! Double))
        //マスに情報セット
        tTrout.setChip(aChip:aChip)
        tTrout.setPosition(aPosition:FeildPosition(x:aPosition.x,y:aPosition.y,z:aPosition.z))
        return tTrout
    }
    //マスの形を決定
    static func makeShape(aNum:Float)->MapTrout{
        switch Int(aNum*100)%100 {
        case 0:return MapBoxTrout(aDirection:"")//立方体
        //坂道
        case 11:return MapSlopTrout(aDirection:"up")
        case 12:return MapSlopTrout(aDirection:"down")
        case 13:return MapSlopTrout(aDirection:"left")
        case 14:return MapSlopTrout(aDirection:"right")
        default:print("マスの形が不正な数値だよ→",aNum)
        }
        return MapTrout(aShape:"",aDirection:"")
    }
}
