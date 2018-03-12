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
    static func setSettedSkillsList(aNode:SKNode,aSkills:[String]){
        for i in 0...3{
            let tSkillName:String
            let tCategory:SkillCategory
            let tDark:Bool
            if(aSkills[i] != ""){
                //スキルあり
                let tSkillData=SkillDictionary.get(key:aSkills[i])
                tSkillName=tSkillData.name
                tCategory=tSkillData.category
                tDark=false
            }
            else{
                //スキルなし
                tSkillName=""
                tCategory=(i == 3) ?.passive:.physics
                tDark=(i == 2) ?true:false
            }
            //バーにセット
            setSkillBar(
                aNode:aNode.childNode(withName:"skill"+String(i))!,
                aSkillName:tSkillName,
                aCategory:tCategory,
                aDark:tDark
            )
        }
    }
    //習得スキルセット
    static func setMasteredSkillsList(aNode:SKNode,aSkills:[String]){
        for i in 0...3{
            if(aSkills.count<i){
                //スキルなし
                setSkillBar(aNode:aNode.childNode(withName:"skill"+String(i))!,
                    aSkillName:"",
                    aCategory:.physics,
                    aDark:false
                )
                continue
            }
            //スキルあり
            let tSkillName=aSkills[i]
            let tSkillData=SkillDictionary.get(key:tSkillName)
            setSkillBar(aNode:aNode.childNode(withName:"skill"+String(i))!,
                        aSkillName:tSkillData.name,
                        aCategory:tSkillData.category,
                        aDark:false
            )
        }
    }
    //スキルを詰めて表示
    static func stuffedSetSkill(aNode:SKNode,aSkills:[String]){
        var tNum=0
        //スキルなしの部分は詰めて表示
        for tSkillKey in aSkills{
            if(tSkillKey==""){continue}//スキルなし
            let tSkillData=SkillDictionary.get(key:tSkillKey)
            //スキルのバーセット
            setSkillBar(aNode:aNode.childNode(withName:"skill"+String(tNum))!,
                        aSkillName:tSkillData.name,
                        aCategory:tSkillData.category,
                        aDark:false
            )
            tNum+=1
        }
        //余ったバーを透過する
        for i in tNum...3{
            aNode.childNode(withName:"skill"+String(i))!.alpha=0
        }
    }
    //スキルバーセット
    static func setSkillBar(aNode:SKNode,aSkillName:String,aCategory:SkillCategory,aDark:Bool){
        aNode.alpha=1
        //バーの画像名
        var tBarName:String=""
        var tUperFlag=false
        for tChar in(aNode.childNode(withName:"background")!.children[0] as! SKSpriteNode)
            .texture!.description.components(separatedBy:"'")[1].characters{
                if(tUperFlag){tBarName+=String(tChar);continue}
                if(String(tChar)==String(tChar).uppercased()){
                    tUperFlag=true
                    tBarName+=String(tChar)
                }
        }
        tBarName=tBarName.substring(to:tBarName.index(tBarName.endIndex,offsetBy:-1))
        
        //スキル名
        (aNode.childNode(withName:"label")!.childNode(withName:"name") as! SKLabelNode).text=aSkillName
        //スキル種別
        let tBarColor:String
        switch aCategory {
        case .physics:fallthrough//物理
        case .magic:fallthrough//魔法
        case .assist:fallthrough//支援
        case .disturbance://妨害
            tBarColor="blue"
        case .heal://回復
            tBarColor="green"
        case .passive://パッシブ
            tBarColor="red"
        }
        //バーの色変更
        BarMaker.setBarImage(aNode:aNode.childNode(withName:"background")!,aBarName:tBarColor+tBarName)
        //バーの暗転
        if(aDark){
            blendBar(aNode:aNode.childNode(withName:"background")!,
                                   aColor:UIColor(red:0,green:0,blue:0,alpha:1),
                                   aBlend:0.3)
        }
        else{
            blendBar(aNode:aNode.childNode(withName:"background")!,
                     aColor:UIColor(red:0,green:0,blue:0,alpha:0),
                     aBlend:0)
        }
    }
    //バーの変色
    static func blendBar(aNode:SKNode,aColor:UIColor,aBlend:CGFloat){
        for tNode in aNode.children{
            (tNode as! SKSpriteNode).color=aColor
            (tNode as! SKSpriteNode).colorBlendFactor=aBlend
        }
    }
}
