//
//  PygmyImageMaker.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/27.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmyImageMaker{
    //画像セット
    static func setImage(aNode:SKSpriteNode,aPygmy:Pygmy){
        //sksファイルでキャラ画像の位置がわかりやすいように色をつけていた場合、色を消す
        aNode.color=UIColor(red:0,green:0,blue:0,alpha:0)
        
        let tImageData=aPygmy.getImage()
        for tParts in ["body","eye","mouth","accessory"]{
            let tImageName=tImageData.get(parts:tParts,pattern:"normal")
            if(tImageName==nil){//画像がなかった
                (aNode.childNode(withName:tParts) as? SKSpriteNode)?.texture=nil//画像削除
                continue
            }
            //画像を表示
            if let tNode=aNode.childNode(withName:tParts){
                //画像を表示するノードがすでに用意してある
                (tNode as! SKSpriteNode).texture=SKTexture(imageNamed:tImageName!)
            }
            else{
                //ノードがない
                let tNewNode=SKSpriteNode()
                tNewNode.size=aNode.size
                tNewNode.texture=SKTexture(imageNamed:tImageName!)
                tNewNode.name=tParts
                aNode.addChild(tNewNode)
            }
        }
    }
}
