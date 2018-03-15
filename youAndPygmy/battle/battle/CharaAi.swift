//
//  CharaAi.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class CharaAi{
    //ターン終了時に呼ぶ関数
    private static var mEndFunction:(()->())!
    private static var mTurnChara:BattleChara!
    private static var mRoute:[(BattleTrout,[BattlePosition])]!
    static func toAct(aChara:BattleChara,aEndFunction:@escaping ()->()){
        mEndFunction=aEndFunction
        mTurnChara=aChara
        mRoute=RouteSearcher.search(aChara:mTurnChara)
        let tAct:(BattleTrout,String?,BattleChara?)
        switch aChara.getAi() {
        case .tonikakunaguru:
            tAct=tonikakunaguru()
        default:
            print("このAIのキャラをCharaAiクラスに渡さないで→",aChara.getAi())
            return
        }
        mTurnChara.junp {
            //ジャンプしてから行動
            act(aTrout:tAct.0,aSkill:tAct.1,aTargetChara:tAct.2)
        }
    }
    //行動する
    static func act(aTrout:BattleTrout,aSkill:String?,aTargetChara:BattleChara?){
        //移動
        var tSelectedRoute:[BattlePosition]=[]
        for (tTrout,tRoute) in mRoute{
            if(tTrout === aTrout){
                tSelectedRoute=tRoute
                break
            }
        }
        mTurnChara.move(aRoute:tSelectedRoute,aEndFunction:{
            //攻撃
            if(aSkill==nil){//スキルを使わない
                mEndFunction()
                return
            }
            AttackOperator.attack(aChara:mTurnChara,
                                  
                                  aSkill:aSkill!,
                                  aTargetTrout:Battle.getTrout(aTargetChara!.getPosition())!,
                                  aEndFunction:{
                                    mEndFunction()
            })
        })
    }
    //とにかくなぐる
    static func tonikakunaguru()->(BattleTrout,String?,BattleChara?){
        //自分に近い順に相手のキャラを取得
        let tOponents=makeCharaListByEvaluation(aFunction:{(aChara)->(Double?)in
            if(!TeamRelationship.oponent.relative(mTurnChara,aChara)){return nil}
            let tMyPosition=mTurnChara.getPosition()
            let tPosition=aChara.getPosition()
            let tDistance=abs(tMyPosition.x-tPosition.x)+abs(tMyPosition.y-tPosition.y)
            return -Double(tDistance)
        })
        var tFirstAct:(BattleTrout,String?,BattleChara?)?=nil
        for tTargetChara in tOponents{
            let tTargetCharaPosition=tTargetChara.getPosition()
            let tAct=makeTroutListbyEvaluation(aTargetChara:tTargetChara,aFunction:{(aTrout)->(String?,Double)in
                let tSkill=getMaxEvaluationSkill(aTargetChara:tTargetChara,aTrout:aTrout,
                                                 aFunction:{
                                                    let tDamage=DamageCalculator.calculateDamage(aAttacker:mTurnChara,
                                                                                     aDefender:tTargetChara,
                                                                                     aSkill:$0)
                                                    return (tDamage==nil) ?nil:Double(tDamage!)
                }
                )
                if(tSkill.1 != nil){return tSkill as! (String?, Double)}
                let tTroutPosition=aTrout.getPosition()
                let tDistance=abs(tTroutPosition.x-tTargetCharaPosition.x)+abs(tTroutPosition.y-tTargetCharaPosition.y)
                return (nil,-Double(tDistance))
            })
            if(tAct.count==0){continue}
            if(tAct[0].1==nil){
                if(tFirstAct==nil){tFirstAct=(tAct[0].0,nil,nil)}
                continue
            }
            return (tAct[0].0,tAct[0].1!,tTargetChara)
        }
        return tFirstAct!
    }
    //移動可能なマスを評価値の順に並べて使用するスキルとともに返す
    static func makeTroutListbyEvaluation(aTargetChara:BattleChara,
                                          aFunction:(BattleTrout)->(String?,Double))->[(BattleTrout,String?)]{
        var tEvaluation:[(BattleTrout,String?,Double)]=[]
        for (tTrout,_) in mRoute+[(Battle.getTrout(mTurnChara.getPosition())!,[])]{
            let tTroutEvaluation=aFunction(tTrout)
            tEvaluation.append((tTrout,tTroutEvaluation.0,tTroutEvaluation.1))
        }
        tEvaluation=tEvaluation.sorted(by:{
            ($0.0.2==$0.1.2)
            ? arc4random_uniform(1)==1
            : $0.0.2>$0.1.2
        })
        //結果を戻り値の型に合わせる
        var tResult:[(BattleTrout,String?)]=[]
        for (tTrout,tSkill,_) in tEvaluation{
            tResult.append((tTrout,tSkill))
        }
        return tResult
    }
    //全キャラを評価値の順に並べた配列取得
    static func makeCharaListByEvaluation(aFunction:@escaping (BattleChara)->(Double?))->[BattleChara]{
        var tSurviving=CharaManager.getSurvivingCharas()
        //評価値がnilの要素を排除
        tSurviving=tSurviving.filter{
            if(aFunction($0) != nil){return true}
            else{return false}
        }
        tSurviving=tSurviving.sorted(by:{
            let tEvaluation1=aFunction($0)!
            let tEvaluation2=aFunction($1)!
            return (tEvaluation1 != tEvaluation2)
                ? tEvaluation1 > tEvaluation2
                :arc4random_uniform(1)==1
        })
        return tSurviving
    }
    //指定したマスから指定したキャラに対して使えるスキルの中で、評価値がもっとも高いスキルと評価値を返す
    static func getMaxEvaluationSkill(aTargetChara:BattleChara,aTrout:BattleTrout,
                  aFunction:@escaping (String)->(Double?))->(String?,Double?){
        var tResult:[(String?,Double?)]=[]
        let tPosition=aTrout.getPosition()
        let tTargetPosition=aTargetChara.getPosition()
        let tSkills=mTurnChara.getSkill()
        for tSkill in tSkills{
            if(!mTurnChara.canUse(aSkill:tSkill)){continue}//スキルが使えない
            //攻撃範囲取得
            let tRange=SkillRangeSearcher.searchSkillRange(aPosition:tPosition,aSkill:tSkill)
            //攻撃範囲に標的のキャラがいるか
            for (tTrout,_) in tRange{
                let tRangePosition=tTrout.getPosition()
                if(tRangePosition.x != tTargetPosition.x || tRangePosition.y != tTargetPosition.y){continue}
                //攻撃範囲内にいた
                let tEvaluation=aFunction(tSkill)
                if(tEvaluation==nil){continue}
                tResult.append((tSkill,tEvaluation))
                break
            }
        }
        //もっとも評価値が高いスキルを選ぶ
        if(tResult.count==0){return (nil,nil)}
        tResult=tResult.sorted(by:{
            ($0.0.1!==$0.1.1!)
            ? arc4random_uniform(1)==1
            : $0.0.1!>$0.1.1!
        })
        return tResult[0]
    }
}

enum AiType{
    case you
    case tonikakunaguru
}

enum TeamRelationship{
    case fellow//仲間
    case oponent//相手
    func relative(_ chara1:BattleChara,_ chara2:BattleChara)->Bool{
        switch self {
        case .fellow:
            return chara1.getTeam()==chara2.getTeam()
        case .oponent:
            return chara1.getTeam() != chara2.getTeam()
        }
    }
}
