//
//  SkillBarMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/02.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class SkillBarMaker{
    //装備スキルセット
    static func setSettedSkillsList(aNode:SKSpriteNode,aSkills:[String]){
        var tSkills=["","","",""]
        var tAttackNum:Int=0
        var tPassiveNum:Int=0
        for tSkillName in aSkills{
            let tSkillData=SkillDictionary.get(key:tSkillName)
            if(tSkillData.category != .passive){
                //パッシブ以外
                tSkills[tAttackNum]=tSkillName
                tAttackNum+=1
            }
            else{
                //パッシブ
                tSkills[3-tPassiveNum]=tSkillName
                tPassiveNum+=1
            }
        }
        //スキル2を暗転
        blendBar(aNode:aNode.childNode(withName:"skill2")!.childNode(withName:"background") as! SKSpriteNode,
                 aColor:UIColor(red:0,green:0,blue:0,alpha:1),
                 aBlend:0.3)
        //スキル名セット
        for i in 0...3{
            setSkill(aNode:aNode.childNode(withName:"skill"+String(i)) as! SKSpriteNode,aSkill:tSkills[i])
        }
    }
    //習得スキルセット
    static func setMasteredSkillsList(aNode:SKSpriteNode,aSkills:[String]){
        for i in 0...3{
            if(aSkills.count<i){
                //スキルなし
                setSkill(aNode:aNode.childNode(withName:"skill"+String(i)) as! SKSpriteNode,aSkill:"")
                continue
            }
            let tSkillName=aSkills[i]
            let tSkillData=SkillDictionary.get(key:tSkillName)
            if(tSkillData.category != .passive){
                //パッシブ以外
                setSkill(aNode:aNode.childNode(withName:"skill"+String(i)) as! SKSpriteNode,aSkill:tSkillName)
            }
            else{
                //パッシブ
                setSkill(aNode:aNode.childNode(withName:"skill"+String(i)) as! SKSpriteNode,aSkill:tSkillName)
            }
        }
    }
    static func setSkill(aNode:SKSpriteNode,aSkill:String){
        if(aSkill==""){
            //スキルなし
            (aNode.childNode(withName:"label")!.childNode(withName:"name") as! SKLabelNode).text=""
            BarMaker.setBarImage(aNode:aNode.childNode(withName:"background") as! SKSpriteNode,aBarName:"blueNameFrame")
            return
        }
        
        let tSkillData=SkillDictionary.get(key:aSkill)
        //スキル名
        (aNode.childNode(withName:"label")!.childNode(withName:"name") as! SKLabelNode).text=tSkillData.name
        //スキル種別
        if(tSkillData.category != .passive){
            //パッシブ以外
            BarMaker.setBarImage(aNode:aNode.childNode(withName:"background") as! SKSpriteNode,aBarName:"blueNameFrame")
        }
        else{
            //パッシブ
            BarMaker.setBarImage(aNode:aNode.childNode(withName:"background") as! SKSpriteNode,aBarName:"redNameFrame")
        }
    }
    static func blendBar(aNode:SKSpriteNode,aColor:UIColor,aBlend:CGFloat){
        for tNode in aNode.children{
            (tNode as! SKSpriteNode).color=aColor
            (tNode as! SKSpriteNode).colorBlendFactor=aBlend
        }
    }
}
