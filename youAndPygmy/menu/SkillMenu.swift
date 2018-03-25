//
//  SkillMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/21.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class SkillMenu:Menu{
    static let singleton:SkillMenu=SkillMenu()
    var mSettedSkillBars:[SKNode]!=[]
    var mMasteredSkillBars:[SKNode]!=[]
    var mNatureSkillBar:SKNode!
    var mAccessorySkillBar:SKNode!
    var mSettedSkillBox:SKNode!
    var mMasteredSkillBox:SKNode!
    var mDetailsBox:SKNode!
    var mRemoveBox:SKNode!
    private init(){
        super.init(aName:"skill")
    }
    override func createScene(){
        mScene=SKScene(fileNamed:"skillMenu")!
        //ノードを取得し保持
        //装備スキル
        mSettedSkillBox=mScene.childNode(withName:"settedSkillBox")!
        for i in 0...3{
            mSettedSkillBars.append(mSettedSkillBox.childNode(withName:"skill"+String(i))!)
        }
        //習得スキル
        mMasteredSkillBox=mScene.childNode(withName:"masteredSkillBox")!
        for i in 0...3{
            mMasteredSkillBars.append(mMasteredSkillBox.childNode(withName:"skill"+String(i))!)
        }
        //天性特性
        mNatureSkillBar=mScene.childNode(withName:"natureSkill")!
        //アクセサリスキル
        mAccessorySkillBar=mScene.childNode(withName:"accessorySkill")!
        //スキル詳細
        mDetailsBox=mScene.childNode(withName:"details")!
        //スキル外しbox
        mRemoveBox=mScene.childNode(withName:"removeBox")!
        mRemoveBox.alpha=0
        mRemoveBox.setElement("dragOverFunction",{()->()in})
        mRemoveBox.setElement("dropFunction",{(aNode:SKNode)->()in
            if(aNode.getAccessibilityElement("skillPosition") as? String != "setted"){return}
            let tPygmy=You.getAccompanying()[self.mOptions["accompanyingNum"] as! Int]
            tPygmy.removeSettedSkill(aNode.getAccessibilityElement("skillNum") as! Int)
            self.renew()
        })
        //タップイベントセット
        for tBar in mSettedSkillBars+mMasteredSkillBars+[mNatureSkillBar]+[mAccessorySkillBar]{
            tBar.setElement("tapFunction",{()->()in
                if let tSkill=tBar.getAccessibilityElement("skillKey"){
                    self.setDetails(aSkill:tSkill as! String)
                }
            })
        }
        //ドラッグイベントセット
        for tBar in mSettedSkillBars+mMasteredSkillBars{
            DragNodeOperator.setDragEvent(
                aNode:tBar,
                aStart:{(_)->()in
                    if(tBar.getAccessibilityElement("skillPosition") as! String=="setted"){
                        self.mRemoveBox.alpha=1
                    }
            },aDragging:{(_)->()in
            },aEnd:{(_)->()in
                self.mRemoveBox.alpha=0
            })
        }
        //ドロップイベントセット
        for i in 0...3{
            let tBar=mSettedSkillBars[i]
            tBar.setElement("skillNum",i)
            tBar.setElement("skillPosition","setted")
            tBar.setElement("dragOverFunction",{()->()in})
            tBar.setElement("dropFunction",{(aNode:SKNode)->()in//装備スキルにドロップ
                let tPygmy=You.getAccompanying()[self.mOptions["accompanyingNum"] as! Int]
                switch aNode.getAccessibilityElement("skillPosition") as! String{
                case "setted":
                    tPygmy.rearrangeSettedSkill(aNode.getAccessibilityElement("skillNum") as! Int,i)
                case "mastered":
                    tPygmy.setSkill(aSetPosition:i,aSetSkillNum:aNode.getAccessibilityElement("skillNum") as! Int)
                default:break
                }
                self.renew()
            })
        }
        for i in 0...3{
            let tBar=mMasteredSkillBars[i]
            tBar.setElement("skillNum",i)
            tBar.setElement("skillPosition","mastered")
            tBar.setElement("dragOverFunction",{()->()in})
            tBar.setElement("dropFunction",{(aNode:SKNode)->()in//習得スキルにドロップ
                if((aNode.getAccessibilityElement("skillPosition") as! String) != "mastered"){return}
                let tPygmy=You.getAccompanying()[self.mOptions["accompanyingNum"] as! Int]
                tPygmy.rearrangeMasteredSkill(aNode.getAccessibilityElement("skillNum") as! Int,i)
                self.renew()//実機?で実行しないとバグる
            })
        }
        DragNodeOperator.setDragScene(aScene:mScene)
    }
    override func renew(){
        let tPygmy=You.getAccompanying()[mOptions["accompanyingNum"] as! Int]
        SkillBarMaker.setSettedSkillsList(aNode:mSettedSkillBox,aSkills:tPygmy.getSettedSkills())
        SkillBarMaker.setMasteredSkillsList(aNode:mMasteredSkillBox,aSkills:tPygmy.getMasteredSkills())
        if let tSkill=tPygmy.getNatureSkill(){
            //天性特性あり
            SkillBarMaker.setSkillBar(aNode:mNatureSkillBar,aSkill:tSkill,aOptions:[:])
        }
        else{
            //天性特性なし
            SkillBarMaker.setEmptyBar(aNode:mNatureSkillBar,aOptions:["category":SkillCategory.passive])
        }
        SkillBarMaker.setEmptyBar(aNode:mDetailsBox,aOptions:[:])
        if let tAccessory=tPygmy.getAccessory(){
            let tAccessoryData=AccessoryDictionary.get(tAccessory)
            if let tSkill=tAccessoryData.skill{
                //アクセサリスキルあり
                SkillBarMaker.setSkillBar(aNode:mAccessorySkillBar,aSkill:tSkill,aOptions:[:])
            }
            else{
                //アクセサリスキルなし
                SkillBarMaker.setEmptyBar(aNode:mAccessorySkillBar,aOptions:["category":SkillCategory.passive])
            }
        }
    }
    //スキルの説明表示
    func setDetails(aSkill:String){
        SkillBarMaker.setSkillBar(aNode:mDetailsBox,aSkill:aSkill,aOptions:["changeColor":false])
    }
}
