//
//  SkillRangeSearcher.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/11.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SkillRangeSearcher{
    //スキルの場合の攻撃範囲
    static func searchSkillRange(aChara:BattleChara,aSkill:String)->[(BattleTrout,[BattleTrout])]{
        return search(aChara:aChara,aSkillData:SkillDictionary.get(key:aSkill))
    }
//    //アイテムの場合の効果範囲
//    static func searchItemRange(aChara:BattleChara,aItemKey:String)->[(BattleTrout,[BattleTrout])]{
//        return search(aChara:aChara,aSkillData:ItemDictionary.get(key:aItemKey).battleEffect!)
//    }
    //スキルの攻撃範囲を求める
    static func search(aChara:BattleChara,aSkillData:SkillData)->[(BattleTrout,[BattleTrout])]{//[(攻撃範囲,[巻き込み範囲])]
        let tMyPosition=aChara.getPosition()
        var tRange:[(BattlePosition,[BattlePosition])]=[]
        switch aSkillData.range.rangeType {
        case .adjacentIncludeMyself://自身と隣接マス
            tRange.append((tMyPosition,[]))
            fallthrough
        case .adjacent://隣接マス
            tRange.append((tMyPosition+(0,-1),[]))
            tRange.append((tMyPosition+(0,1),[]))
            tRange.append((tMyPosition+(-1,0),[]))
            tRange.append((tMyPosition+(1,0),[]))
        case .rangeIncludeMyself://自分を含む射程
            tRange.append((tMyPosition,[]))
            fallthrough
        case .range://射程
            let tDistance=aSkillData.range.range!
            for x in 0...tDistance{
                for y in 0...tDistance-x{
                    if(x==0&&y==0){continue}
                    tRange.append((tMyPosition+(x,y),[]))
                }
            }
        case .circumferenceIncludeMyself://自分を含む周囲
            tRange.append((tMyPosition,[]))
            fallthrough
        case .circumference://周囲
            var tCircumference:[BattlePosition]=[]
            for i in 1...aSkillData.range.range!{
                //y=i
                for x in -i...i{
                    tCircumference.append(tMyPosition+(x,i))
                    tCircumference.append(tMyPosition+(x,-i))
                }
                //x=i
                for y in -i+1...i-1{
                    tCircumference.append(tMyPosition+(i,y))
                    tCircumference.append(tMyPosition+(-i,y))
                }
            }
            for tPosition in tCircumference{
                //選択したマスを巻き込み範囲から削除
                var tInvolvement=tCircumference
                for i in 0..<tInvolvement.count{
                    let tCircumferencePosition=tInvolvement[i]
                    if(tCircumferencePosition.x != tPosition.x || tCircumferencePosition.y != tPosition.y){continue}
                    tInvolvement.remove(at:i)
                    break
                }
                tRange.append((tPosition,tInvolvement))
            }
        case .myself://自身
            tRange.append((tMyPosition,[]))
        case .line://直線
            let tDistance=aSkillData.range.range
            for tDirection in [(0,-1),(0,1),(-1,0),(1,0)]{
                for i in 1...tDistance!{
                    //巻き込み範囲算出
                    var tInvolvement:[BattlePosition]=[]
                    for j in 1...tDistance!{
                        if(i==j){continue}
                        tInvolvement.append(tMyPosition+(tDirection.0*j,tDirection.1*j))
                    }
                    tRange.append(((tMyPosition+(tDirection.0*i,tDirection.1*i),tInvolvement)))
                }
            }
        }
        //座標をマスに変換して返す
        var tReturn:[(BattleTrout,[BattleTrout])]=[]
        for (tTarget,tInvolvement) in tRange{
            let tTargetTrout=Battle.getTrout(aPosition:tTarget)
            if(tTargetTrout==nil){continue}//攻撃対象にするマスがない
            var tInvolvementRange:[BattleTrout]=[]
            //巻き込み範囲変換
            for tInvolvementPosition in tInvolvement{
                if let tInvolvementTrout=Battle.getTrout(aPosition:tInvolvementPosition){
                    tInvolvementRange.append(tInvolvementTrout)
                }
            }
            tReturn.append((tTargetTrout!,tInvolvementRange))
        }
        return tReturn
    }
}
