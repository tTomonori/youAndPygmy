//
//  RouteSearcher.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class RouteSearcher{
    //移動可能なマスと、そこへの経路を求める
    static func search(aChara:BattleChara)->[(BattleTrout,[BattlePosition])]{
        let tStartingPosition=aChara.getPosition()
        let tMobility=aChara.getMobility()
        //暫定最短経路
        var tSearched:[(Double,BattlePosition,[BattlePosition])]=[]//(移動コスト,移動先の座標,移動経路)
        //これから調べる座標
        var tSearching:[(Double,BattlePosition,[BattlePosition])]//(移動コスト,調べる座標,移動経路)
        tSearching=[(0,tStartingPosition,[tStartingPosition])]
        //経路探索
        while(tSearching.count>0){
            //次に調べるマスのデータを取り出す
            let tSearchingPosition=tSearching.removeFirst()
            //隣接したマスを調べる
            search_neighbor:for tDifference in [(0,-1),(0,1),(-1,0),(1,0)]{
                //隣接したマスの座標
                let tNeighborPosition=BattlePosition(
                    x:tSearchingPosition.1.x+tDifference.0,
                    y:tSearchingPosition.1.y+tDifference.1)
                //隣接したマス
                let tNeighborTrout=Battle.getTrout(aPosition:tNeighborPosition)
                if(tNeighborTrout==nil){continue}//隣接したマスがない
                if(tMobility.get(key:tNeighborTrout!.getAttribute())<0){continue}//通過できない地形
                if(tNeighborTrout!.getRidingChara() != nil){continue}//隣接したマスに他のキャラがいる
                //隣接したマスへの経路
                let tRouteToNeighbor=(
                    tSearchingPosition.0+tMobility.get(key:tNeighborTrout!.getAttribute()),
                    tNeighborPosition,
                    tSearchingPosition.2+[tNeighborPosition]
                )
                //探索済みの経路を探してコストを比較
                for i in 0..<tSearched.count{
                    let tSearchedPosition=tSearched[i]
                    if(tSearchedPosition.1.x != tNeighborPosition.x || tSearchedPosition.1.y != tNeighborPosition.y){continue}
                    //既存のルートの方が低コスト
                    if(tSearchingPosition.0<=tRouteToNeighbor.0){continue search_neighbor}
                    //新たなルートの方が低コスト
                    tSearched.remove(at:i)//既存のルート削除
                    break
                }
                //暫定最短ルートとして登録
                tSearched.append(tRouteToNeighbor)
                //移動コストがオーバーしていなければ、調べる座標に登録
                if(tMobility.mov>tRouteToNeighbor.0){tSearching.append(tRouteToNeighbor)}
            }
        }
        //探索結果を戻り値の型に変換
        var tReturn:[(BattleTrout,[BattlePosition])]=[]
        for tSearchedData in tSearched{
            tReturn.append((Battle.getTrout(aPosition:tSearchedData.1)!,tSearchedData.2))
        }
        return tReturn
    }
}
