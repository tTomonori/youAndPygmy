//
//  MapSlopTrout.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/17.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class MapSlopTrout:MapTrout{
    init(aDirection:String){
        super.init(aShape:"slop",aDirection:aDirection)
    }
    //マスの高さ設定
    override func setHeight(aDirection:String){
        //坂道
        mCenterHeight=0.5
        switch aDirection {
        case "up":
            mUpHeight=0
            mDownHeight=1
            mLeftHeight=0.5
            mRightHeight=0.5
        case "down":
            mUpHeight=1
            mDownHeight=0
            mLeftHeight=0.5
            mRightHeight=0.5
        case "left":
            mUpHeight=0.5
            mDownHeight=0.5
            mLeftHeight=0
            mRightHeight=1
        case "right":
            mUpHeight=0.5
            mDownHeight=0.5
            mLeftHeight=1
            mRightHeight=0
        default:print("slop型のマスの高さ設定ができないよ→",aDirection)
        }
    }
}
