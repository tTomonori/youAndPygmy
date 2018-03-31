//
//  PygmySelector.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/30.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmySelector{
    private static let mSelector=createSelector()//サイズ 600x220
    private static var mPygmiesBox:[SKNode]!//ぴぐみーの情報表示ノード
    private static var mPygmies:[Pygmy]!//手持ちぴぐみー
    private static var mSelectedFunction:((Pygmy)->())!//選択された時に実行する関数
    //セレクタ生成
    private static func createSelector()->SKNode{
        let tScene=SKScene(fileNamed:"pygmySelector")!
        let tSelector=tScene.childNode(withName:"selector")!
        mPygmiesBox=[]
        for i in 0...4{//ぴぐみーの情報ノード
            let tAccompanying=tSelector.childNode(withName:"accompanying"+String(i))!
            mPygmiesBox.append(tAccompanying)
            tAccompanying.setElement("tapFunction",{()->()in
                self.selected(i)
            })
        }
        tSelector.removeFromParent()
        return tSelector
    }
    //ぴぐみーが選択された
    static func selected(_ num:Int){
        if(mPygmies.count<=num){return}
        mSelectedFunction(mPygmies[num])
    }
    //表示更新
    static func renew(){
        let tPygmyNum=mPygmies.count
        for i in 0..<mPygmiesBox.count{
            if(i<tPygmyNum){
                PygmyInformation.set(aNode:mPygmiesBox[i],aPygmy:mPygmies[i])
            }
            else{
                PygmyInformation.blackOut(aNode:mPygmiesBox[i])
            }
        }
    }
    //指定したノードに表示
    static func show(aNode:SKNode,aFunction:@escaping (Pygmy)->()){
        mSelectedFunction=aFunction
        aNode.addChild(mSelector)
        mPygmies=You.getAccompanying()
    }
    //非表示
    static func hide(){
        mSelector.removeFromParent()
        mPygmies=nil
    }
}
