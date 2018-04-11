//
//  Result.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/04/07.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class Result{
    private static let mScene=createScene()
    private static let mAccompanies:[SKNode]=getAccompanyingNodes()
    private static let mDrops:[SKNode]=getDropNodes()
    private static var mEndFunction:(()->())!
    //戦闘リザルトセット
    static func result(aAllies:[BattleChara],aDrop:[(String,ItemCategory,Int)],aExperience:Int,aEndFunction:@escaping ()->()){
        mEndFunction=aEndFunction
        //戦闘後のステータス反映
        let tPygmies=You.getBattleParticipants(aNum:aAllies.count)
        for i in 0..<aAllies.count{
            let tData=aAllies[i]
            let tPygmy=tPygmies[i]
            //hp
            var tCurrentHp=tData.getCurrentHp()
            if(tCurrentHp>0){
                //補正値分減算
                tCurrentHp -= tPygmy.getCorrection().hp
                if(tCurrentHp<0){tCurrentHp=1}
            }
            tPygmy.setCurrentHp(aHp:tCurrentHp)
            //アイテム
            let tItem=tData.getItem()
            if let tItemName=tItem.0{//アイテムが残っている
             let _=tPygmy.haveItem(aItem:tItemName,aNum:tItem.1)
            }
            else{//アイテムが残っていない
                let _=tPygmy.returnItem()
            }
        }
        //ぴぐみー情報表示
        for i in 0..<aAllies.count{
            let tNode=mAccompanies[i]
            let tPygmy=tPygmies[i]
            PygmyInformation.set(aNode:tNode,aPygmy:tPygmy)
        }
        //ぴぐみーがいないバー
        for i in aAllies.count...4{
            let tNode=mAccompanies[i]
            PygmyInformation.blackOut(aNode:tNode)
        }
        //ドロップアイテム
        let tGettedItems=judgeDrop(aDropList:aDrop)
        for i in 0..<tGettedItems.count{
            let tItem=tGettedItems[i]
            //アイテムをバッグへ
            let tBag=YouBag.getBag(tItem.1)
            tBag.add(aItem:tItem.0,aNum:tItem.2)
            //ドロップ一覧に表示
            let tNode=mDrops[i]
            tNode.alpha=1
            ItemBarMaker.setItemBar(aNode:tNode,aItem:(tItem.0,tItem.2),aCategory:tItem.1)
        }
        //不要なアイテムバー透過
        for i in tGettedItems.count...9{
            let tNode=mDrops[i]
            tNode.alpha=0
        }
        //経験値取得
    }
    //次へ(画面タップ)
    static func tapped(){
        mEndFunction()
    }
    //シーン表示
    static func show(){
        gGameViewController.set2dScene(aScene:mScene)
    }
    //ドロップしたアイテム決定([(キー,カテゴリ,ドロップ率)]を引数として[(キー,カテゴリ,個数)]を返す)
    static func judgeDrop(aDropList:[(String,ItemCategory,Int)])->[(String,ItemCategory,Int)]{
        var tDropItems:[(String,ItemCategory,Int)]=[]
        Drop: for tItem in aDropList{
            if(tItem.2<Int(arc4random_uniform(100))){continue}//ドロップしない
            //ドロップした
            //リストに同じアイテムがあるか確認
            for i in 0..<tDropItems.count{
                if((tDropItems[i].0 != tItem.0) || (tDropItems[i].1 != tItem.1)){continue}
                //複数個ドロップ
                tDropItems[i].2+=1
                continue Drop
            }
            //ドロップリストに追加
            tDropItems.append((tItem.0,tItem.1,1))
        }
        return tDropItems
    }
    //シーン作成
    private static func createScene()->SKScene{
        let tScene=SKScene(fileNamed:"result")!
        tScene.childNode(withName:"screen")!.setElement("tapEventType","block")
        tScene.childNode(withName:"cover")!.setElement("tapFunction",{()->()in self.tapped()})
        return tScene
    }
    //手持ちキャラの情報ノード取得
    private static func getAccompanyingNodes()->[SKNode]{
        var tNodes:[SKNode]=[]
        for i in 0...4{
            tNodes.append(mScene.childNode(withName:"accompanying"+String(i))!)
        }
        return tNodes
    }
    //ドロップアイテム表示ノード取得
    private static func getDropNodes()->[SKNode]{
        var tNodes:[SKNode]=[]
        let tBox=mScene.childNode(withName:"dropList")!.childNode(withName:"items")!
        for i in 0...9{
            tNodes.append(tBox.childNode(withName:"itemBox"+String(i))!)
        }
        return tNodes
    }
}
