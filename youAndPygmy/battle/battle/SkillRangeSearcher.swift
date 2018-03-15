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
    static func searchSkillRange(aPosition:BattlePosition,aSkill:String)->[(BattleTrout,[BattleTrout])]{
        return search(aPosition:aPosition,aSkillData:SkillDictionary.get(aSkill))
    }
    //スキルの攻撃範囲を求める
    static func searchRange(aPosition:BattlePosition,aSkill:String)->[BattleTrout]{
        var tReturnRange:[BattlePosition]=[]
        let tSkillData=SkillDictionary.get(aSkill)
        switch tSkillData.range.rangeType {
        case .adjacentIncludeMyself://自身と隣接マス
            tReturnRange.append(aPosition)
            fallthrough
        case .adjacent://隣接マス
            tReturnRange.append(aPosition+(0,-1))
            tReturnRange.append(aPosition+(0,1))
            tReturnRange.append(aPosition+(-1,0))
            tReturnRange.append(aPosition+(1,0))
        case .rangeIncludeMyself://自分を含む射程
            tReturnRange.append(aPosition)
            fallthrough
        case .range://射程
            let tDistance=tSkillData.range.range!
            for x in -tDistance...tDistance{
                for y in -tDistance+abs(x)...tDistance-abs(x){
                    if(x==0&&y==0){continue}
                    tReturnRange.append(aPosition+(x,y))
                }
            }
        case .circumferenceIncludeMyself://自分を含む周囲
            tReturnRange.append(aPosition)
            fallthrough
        case .circumference://周囲
            for i in 1...tSkillData.range.range!{
                //y=i
                for x in -i...i{
                    tReturnRange.append(aPosition+(x,i))
                    tReturnRange.append(aPosition+(x,-i))
                }
                //x=i
                for y in -i+1...i-1{
                    tReturnRange.append(aPosition+(i,y))
                    tReturnRange.append(aPosition+(-i,y))
                }
            }
        case .myself://自身
            tReturnRange.append(aPosition)
        case .line://直線
            let tDistance=tSkillData.range.range!
            for tDirection in [(0,-1),(0,1),(-1,0),(1,0)]{
                for i in 1...tDistance{
                    tReturnRange.append(aPosition+(i*tDirection.0,i*tDirection.1))
                }
            }
        }
        var tReturn:[BattleTrout]=[]
        //座標をマスに変換
        for tPosition in tReturnRange{
            let tTrout=Battle.getTrout(tPosition)
            if(tTrout==nil){continue}
            tReturn.append(tTrout!)
        }
        return tReturn
    }
    //スキルの巻き込み範囲を求める
    static func searchInvolvement(aPosition:BattlePosition,aTargetPosition:BattlePosition,aSkill:String)->[BattleTrout]{
        var tReturnRange:[BattlePosition]=[]
        let tSkillData=SkillDictionary.get(aSkill)
        switch tSkillData.range.rangeType {
        case .adjacentIncludeMyself://自身と隣接マス
            break
        case .adjacent://隣接マス
            break
        case .rangeIncludeMyself://自分を含む射程
            break
        case .range://射程
            break
        case .circumferenceIncludeMyself://自分を含む周囲
            fallthrough
        case .circumference://周囲
            for i in 1...tSkillData.range.range!{
                //y=i
                for x in -i...i{
                    tReturnRange.append(aPosition+(x,i))
                    tReturnRange.append(aPosition+(x,-i))
                }
                //x=i
                for y in -i+1...i-1{
                    tReturnRange.append(aPosition+(i,y))
                    tReturnRange.append(aPosition+(-i,y))
                }
            }
            //攻撃目標の座標を除く
            tReturnRange=tReturnRange.filter({
                !(($0.x == aTargetPosition.x) && ($0.y == aTargetPosition.y))
            })
        case .myself://自身
            break
        case .line://直線
            //攻撃した方向を求める
            var tDirection=BattlePosition(x:aTargetPosition.x-aPosition.x,y:aTargetPosition.y-aPosition.y)
            if(tDirection.x != 0){tDirection=BattlePosition(x:tDirection.x/abs(tDirection.x),y:0)}
            else{tDirection=BattlePosition(x:0,y:tDirection.y/abs(tDirection.y))}
            //方向から巻き込み範囲を求める
            
            for i in 1...tSkillData.range.range{
                let tPosition=aPosition+(i*tDirection.x,i*tDirection.y)
                if(tPosition.x==aTargetPosition.x && tPosition.y==aTargetPosition.y){continue}
                tReturnRange.append(tPosition)
            }
        }
        var tReturn:[BattleTrout]=[]
        //座標をマスに変換
        for tPosition in tReturnRange{
            let tTrout=Battle.getTrout(tPosition)
            if(tTrout==nil){continue}
            tReturn.append(tTrout!)
        }
        return tReturn
    }
    //スキルの攻撃範囲を求める
    static func search(aPosition:BattlePosition,aSkillData:SkillData)->[(BattleTrout,[BattleTrout])]{//[(攻撃範囲,[巻き込み範囲])]
        var tRange:[(BattlePosition,[BattlePosition])]=[]
        switch aSkillData.range.rangeType {
        case .adjacentIncludeMyself://自身と隣接マス
            tRange.append((aPosition,[]))
            fallthrough
        case .adjacent://隣接マス
            tRange.append((aPosition+(0,-1),[]))
            tRange.append((aPosition+(0,1),[]))
            tRange.append((aPosition+(-1,0),[]))
            tRange.append((aPosition+(1,0),[]))
        case .rangeIncludeMyself://自分を含む射程
            tRange.append((aPosition,[]))
            fallthrough
        case .range://射程
            let tDistance=aSkillData.range.range!
            for x in -tDistance...tDistance{
                for y in -tDistance+abs(x)...tDistance-abs(x){
                    if(x==0&&y==0){continue}
                    tRange.append((aPosition+(x,y),[]))
                }
            }
        case .circumferenceIncludeMyself://自分を含む周囲
            tRange.append((aPosition,[]))
            fallthrough
        case .circumference://周囲
            var tCircumference:[BattlePosition]=[]
            for i in 1...aSkillData.range.range!{
                //y=i
                for x in -i...i{
                    tCircumference.append(aPosition+(x,i))
                    tCircumference.append(aPosition+(x,-i))
                }
                //x=i
                for y in -i+1...i-1{
                    tCircumference.append(aPosition+(i,y))
                    tCircumference.append(aPosition+(-i,y))
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
            tRange.append((aPosition,[]))
        case .line://直線
            let tDistance=aSkillData.range.range
            for tDirection in [(0,-1),(0,1),(-1,0),(1,0)]{
                for i in 1...tDistance!{
                    //巻き込み範囲算出
                    var tInvolvement:[BattlePosition]=[]
                    for j in 1...tDistance!{
                        if(i==j){continue}
                        tInvolvement.append(aPosition+(tDirection.0*j,tDirection.1*j))
                    }
                    tRange.append(((aPosition+(tDirection.0*i,tDirection.1*i),tInvolvement)))
                }
            }
        }
        //座標をマスに変換して返す
        var tReturn:[(BattleTrout,[BattleTrout])]=[]
        for (tTarget,tInvolvement) in tRange{
            let tTargetTrout=Battle.getTrout(tTarget)
            if(tTargetTrout==nil){continue}//攻撃対象にするマスがない
            var tInvolvementRange:[BattleTrout]=[]
            //巻き込み範囲変換
            for tInvolvementPosition in tInvolvement{
                if let tInvolvementTrout=Battle.getTrout(tInvolvementPosition){
                    tInvolvementRange.append(tInvolvementTrout)
                }
            }
            tReturn.append((tTargetTrout!,tInvolvementRange))
        }
        return tReturn
    }
}
