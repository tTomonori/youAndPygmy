//
//  MapBoxTrout.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/17.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class MapBoxTrout:MapTrout{
    init(aDirection:String){
        super.init(aShape:"box",aDirection:aDirection)
    }
    //マスの高さ設定
    override func setHeight(aDirection:String){
        //平地
        mCenterHeight=1
        mUpHeight=1
        mDownHeight=1
        mLeftHeight=1
        mRightHeight=1
    }
}
