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
    static func setSettedSkillsList(aNode:SKNode,aSkills:[String?]){
        for i in 0...3{
            let tBar=aNode.childNode(withName:"skill"+String(i))!
            if let tSkill=aSkills[i]{
                //スキルあり
                setSkillBar(aNode:tBar,aSkill:tSkill,aOptions:[:])
            }
            else{
                //スキルなし
                var tOptions:Dictionary<String,Any>=[:]
                if(i==2){tOptions["dark"]=true}
                tOptions["category"]=(i==3) ?SkillCategory.passive:SkillCategory.physics
                setEmptyBar(aNode:tBar,aOptions:tOptions)
            }
        }
    }
    //習得スキルセット
    static func setMasteredSkillsList(aNode:SKNode,aSkills:[String?]){
        for i in 0...3{
            let tBar=aNode.childNode(withName:"skill"+String(i))!
            if let tSkill=aSkills[i]{
                //スキルあり
                setSkillBar(aNode:tBar,aSkill:tSkill,aOptions:[:])
            }
            else{
                //スキルなし
                let tOptions:Dictionary<String,Any>=["category":SkillCategory.physics]
                setEmptyBar(aNode:tBar,aOptions:tOptions)
            }
        }
    }
    //スキルを詰めて表示
    static func stuffedSetSkill(aNode:SKNode,aSkills:[String?]){
        var tNum=0
        //スキルなしの部分は詰めて表示
        for tSkillKey in aSkills{
            if(tSkillKey==nil){continue}//スキルなし
            //スキルのバーセット
            setSkillBar(aNode:aNode.childNode(withName:"skill"+String(tNum))!,aSkill:tSkillKey!,aOptions:[:])
            tNum+=1
        }
        //余ったバーを透過する
        for i in tNum...3{
            aNode.childNode(withName:"skill"+String(i))!.alpha=0
        }
    }
    //スキルバーセット
    static func setSkillBar(aNode:SKNode,aSkill:String,aOptions:Dictionary<String,Any>){
        aNode.accessibilityValue=aSkill
        aNode.childNode(withName:"label")!.alpha=1
        blendBar(aNode:aNode.childNode(withName:"background")!,
                 aColor:UIColor(red:0,green:0,blue:0,alpha:0),
                 aBlend:0)
        let tSkillData=SkillDictionary.get(aSkill)
        let tDataNode=aNode.childNode(withName:"label")!
        //バーの色
        let tFlag=aOptions["changeColor"]
        if(tFlag == nil){changeBarColor(aNode:aNode,aCategory:tSkillData.category)}
        //スキル名
        (tDataNode.childNode(withName:"name") as? SKLabelNode)?.text=tSkillData.name
        //詳細
        (tDataNode.childNode(withName:"details") as? SKLabelNode)?.text=tSkillData.details
        //種別
        (tDataNode.childNode(withName:"category") as? SKLabelNode)?.text=tSkillData.category.name()
        //威力
        (tDataNode.childNode(withName:"power") as? SKLabelNode)?.text=String(tSkillData.power)
        //mp
        (tDataNode.childNode(withName:"mp") as? SKLabelNode)?.text=String(tSkillData.mp)
        
        setOption(aNode:aNode,aOptions:aOptions)
    }
    //空のスキルバーセット
    static func setEmptyBar(aNode:SKNode,aOptions:Dictionary<String,Any>){
        aNode.accessibilityValue=nil
        aNode.childNode(withName:"label")!.alpha=0
        setOption(aNode:aNode,aOptions:aOptions)
    }
    //バーセットのオプション
    static func setOption(aNode:SKNode,aOptions:Dictionary<String,Any>){
        //バーの暗転
        if let _=aOptions["dark"]{//暗転
            blendBar(aNode:aNode.childNode(withName:"background")!,
                     aColor:UIColor(red:0,green:0,blue:0,alpha:1),
                     aBlend:0.3)
        }
        else{//明転
            blendBar(aNode:aNode.childNode(withName:"background")!,
                     aColor:UIColor(red:0,green:0,blue:0,alpha:0),
                     aBlend:0)
        }
        //バーの色
        if let tCategory=aOptions["category"]{
            changeBarColor(aNode:aNode,aCategory:tCategory as! SkillCategory)
        }
    }
    //バーの暗転,明転
    static func blendBar(aNode:SKNode,aColor:UIColor,aBlend:CGFloat){
        for tNode in aNode.children{
            (tNode as! SKSpriteNode).color=aColor
            (tNode as! SKSpriteNode).colorBlendFactor=aBlend
        }
    }
    //バーの色変更
    static func changeBarColor(aNode:SKNode,aCategory:SkillCategory){
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
    }
}
