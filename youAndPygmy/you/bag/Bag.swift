//
//  Bag.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/27.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class Bag{
    private var mItems:[(String,Int)]
    init(_ aItems:[(String,Int)]) {
        mItems=aItems
    }
    func set(_ aItems:[(String,Int)]){
        mItems=aItems
    }
    //持っているアイテムの種類の数
    func count()->Int{return mItems.count}
    //指定したアイテムの個数取得
    func get(aItem:String)->(String?,Int){
        for (tName,tNum) in mItems{
            if(tName != aItem){continue}
            return (tName,tNum)
        }
        return (nil,0)
    }
    //アイテムをバッグに入れる
    func add(aItem:String,aNum:Int){
        for i in 0..<mItems.count{
            let (tName,tNum)=mItems[i]
            if(tName != aItem){continue}
            //手に入れたアイテムをすでに所持していた
            mItems[i]=(aItem,tNum+aNum)
            return
        }
        //手に入れたアイテムを１つも所持していない
        mItems.append((aItem,aNum))
    }
    //アイテムを取り出す
    func remove(aItem:String,aNum:Int)->Bool{
        for i in 0..<mItems.count{
            let (tName,tNum)=mItems[i]
            if(tName != aItem){continue}
            if(aNum>tNum){return false}//数が足りない
            if(aNum==tNum){//アイテムがちょうど0個になる
                mItems.remove(at:i)
                return true
            }
            //アイテムの数を減らす
            mItems[i]=(tName,tNum-aNum)
            return true
        }
        //アイテムを持っていない
        return false
    }
    //指定したインデックスからアイテムリスト生成
    func subList(at:Int,num:Int)->[(String?,Int)]{
        var tList:[(String?,Int)]=[]
        let tLength=mItems.count
        for i in 0..<num{
            if(tLength<=at+i){
                tList.append((nil,0))
            }
            else{
                let (tName,tNum)=mItems[at+i]
                tList.append((tName,tNum))
            }
        }
        return tList
    }
}
