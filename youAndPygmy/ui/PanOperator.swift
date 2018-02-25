//
//  PanOperator.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/19.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PanOperator{
    //パン開始地点
    private static var mStartingPoint:CGPoint!
    //前回のパン入力地点
    private static var mPreveousPoint:CGPoint!
    //パン入力の基点
    private static var mBasePoint:CGPoint!
    //パン入力中の方向
    private static var mPanningDirection:String=""
    //パン操作された
    static func pan(aRecognizer:UIGestureRecognizer){
        switch aRecognizer.state {
        case .began://パン開始
            let tPoint=aRecognizer.location(in:nil)
            mStartingPoint=tPoint
            mPreveousPoint=tPoint
            mBasePoint=tPoint
        case .changed://パン入力
            let tCurrentPoint=aRecognizer.location(in:nil)
//            let tPreveousPoint=mPreveousPoint
            mPreveousPoint=tCurrentPoint
            
            let tPanDirection=tCurrentPoint-mBasePoint
            //ドラッグ距離が短い場合
            if(abs(tPanDirection.x)<10&&abs(tPanDirection.y)<10){
                mPanningDirection=""
                return
            }
            //ドラッグ方向を四方向に変換
            if(abs(tPanDirection.x)<abs(tPanDirection.y)){
                //上下方向の方が大きい
                if(tPanDirection.y<0){mPanningDirection="up"}
                else{mPanningDirection="down"}
            }else{
                //左右方向の方が大きい
                if(tPanDirection.x<0){mPanningDirection="left"}
                else{mPanningDirection="right"}
            }
        case .ended://パン終了
            mStartingPoint=nil
            mPreveousPoint=nil
            mPanningDirection=""
        default:
            return
        }
    }
    //パン入力中の方向を返す
    static func getDirection()->String{
        return mPanningDirection
    }
}
