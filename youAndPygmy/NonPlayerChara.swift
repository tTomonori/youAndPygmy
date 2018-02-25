//
//  NonPlayerChara.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/14.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SceneKit

class NonPlayerChara : MapChara{
    var mNpcData:NpcData
    init(aData:NpcData){
        mNpcData=aData
        super.init(aPosition:aData.position,aImageName:aData.imageName)
    }
    //話しかけた(調べた)時のイベントを取得
    override func getSpeakEvents()->[Dictionary<String,Any>]{
        return mNpcData.speakEvents
    }
}
