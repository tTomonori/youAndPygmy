//
//  ActiveSkillUi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/12.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ActiveSkillUi{
    //使用可能なスキル表示ノード
    private static let mSkillBox=BattleUiScene.getNode(aName:"choiceSkillBox")!
    //使用可能なアイテム表示ノード
    private static let mItemBox=mSkillBox.childNode(withName:"itemBox")!
    //セットされたスキルのキーのリスト
    private static var mSkills:[(String,Bool)]!//(スキルキー,使用可能か)
    //セットされたスキルのキー取得
    static func getSkills()->[(String,Bool)]{
        return mSkills
    }
    //表示
    static func display(){
        mSkillBox.alpha=1
    }
    //非表示
    static func hide(){
        mSkillBox.alpha=0
    }
    //アクティブスキルセット
    static func set(aChara:BattleChara){
        mSkills=[]
        let tSkills=aChara.getSkill()
        var tBarNum=0
        for tSkill in tSkills{
            let tSkillData=SkillDictionary.get(tSkill)
            if(tSkillData.category == .passive){continue}//パッシブスキル
            var tOptions:Dictionary<String,Any>=[:]
            let tCanUse=aChara.canUse(aSkill:tSkill)//スキルを使えるか
            if(!tCanUse){tOptions["dark"]=true}
            //スキルのバーセット
            let tSkillBar=mSkillBox.childNode(withName:"skill"+String(tBarNum))!
            SkillBarMaker.setSkillBar(aNode:tSkillBar,aSkill:tSkill,aOptions:tOptions)
            let tLabel=tSkillBar.childNode(withName:"label")!
            //威力
            (tLabel.childNode(withName:"power") as! SKLabelNode).text
                = (tSkillData.category == .physics || tSkillData.category == .magic)
                ?String(tSkillData.power)
                :"-"
            //やる気
            (tLabel.childNode(withName:"mp") as! SKLabelNode).text=String(tSkillData.mp)
            
            mSkills.append((tSkill,tCanUse))
            tBarNum+=1
        }
        //余ったバーを透過する
        for i in tBarNum...3{
            mSkillBox.childNode(withName:"skill"+String(i))!.alpha=0
            mSkills.append(("",false))
        }
        //アイテム表示
        let tItem=aChara.getItem()
        if(tItem.0 != nil){
            let tKey=ItemDictionary.get(tItem.0!).effectKey!
            let tItemEffect=SkillDictionary.get(tKey)
            if(tItemEffect.category != .passive){
                mItemBox.alpha=1
                ItemBarMaker.setItemLabel(aNode:mItemBox,aItem:tItem)
                mSkills.append((tKey,true))
            }
            else{
                //パッシブアイテム
                mItemBox.alpha=0
                mSkills.append((tKey,false))
            }
        }
        else{
            //アイテムなし
            mItemBox.alpha=0
            mSkills.append(("",false))
        }
    }
}
