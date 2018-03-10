//
//  SkillRangeSearcher.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/11.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class SkillRangeSearcher{
    //スキルの攻撃範囲を求める
    static func search(aChara:BattleChara,aSkill:String)->[(BattleTrout,[BattleTrout])]{//[(攻撃範囲,[巻き込み範囲])]
        let tSkillData=SkillDictionary.get(key:aSkill)
        let tMyPosition=aChara.getPosition()
        var tRange:[(BattlePosition,[BattlePosition])]=[]
        switch tSkillData.range.rangeType {
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
            let tDistance=tSkillData.range.range!
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
            for i in 1...tSkillData.range.range!{
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
                tRange.append((tPosition,tCircumference))
            }
        case .myself://自身
            tRange.append((tMyPosition,[]))
        case .line://直線
            let tDistance=tSkillData.range.range
            for tDirection in [(0,-1),(0,1),(-1,0),(1,0)]{
                var tInvolvement:[BattlePosition]=[]
                //巻き込み範囲算出
                for i in 1...tDistance!{
                    tInvolvement.append(BattlePosition(x:tDirection.0*i,y:tDirection.1*i))
                }
                for i in 1...tDistance!{
                    tRange.append((tMyPosition+(tDirection.0*i,tDirection.1*i),tInvolvement))
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
