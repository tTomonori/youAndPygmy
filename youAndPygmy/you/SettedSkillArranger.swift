//
//  SettedSkillArranger.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/25.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SettedSkillArranger{
    static func rearrenge(aList:[String?],aInsertSkill:String,aInsertIndex:Int)->[String?]{
        var tNewList=aList
        for i in 0...3{
            let tSkill=tNewList[i]
            if(tSkill==nil){continue}
            if(tSkill! == aInsertSkill){//セットしようとしたスキルが既にセットしてある
                tNewList[i]=aList[aInsertIndex]
                break
            }
        }
        tNewList[aInsertIndex]=aInsertSkill//スキルセット
        return isRegular(tNewList) ? tNewList:aList
    }
    static func rearrenge(aList:[String?],removeNum:Int)->[String?]{
        var tNewList=aList
        tNewList.remove(at:removeNum)
        tNewList.insert(nil,at:2)
        return isRegular(tNewList) ? tNewList:aList
    }
    //スキルが正しい順になっている
    static func isRegular(_ aList:[String?])->Bool{
        var tRightList=["","","empty"]
        if let tSkill=aList[3]{
            let tSkillData=SkillDictionary.get(tSkill)
            if(tSkillData.category != .passive){return false}
        }
        for i in 0...2{
            switch tRightList[i] {
            case ""://特技スキルならok
                if let tSkill=aList[i]{
                    let tSkillData=SkillDictionary.get(tSkill)
                    if(tSkillData.category == .passive){return false}
                }
            case "passive"://特技でも特性でもok
                break
            case "empty"://スキルなしでなきゃダメ
                if(aList[i] != nil){return false}
            default:
                print("SettedSkillArrangerでたぶん綴りミスってるよ",tRightList)
                return false
            }
            //スキルなしならそれ以降もなし
            if(aList[i]==nil){
                for j in i...2{
                    tRightList[j]="empty"
                }
            }
        }
        return true
    }
}
