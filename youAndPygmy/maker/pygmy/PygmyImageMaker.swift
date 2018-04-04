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
    static func setImage(aNode:SKNode,aImageData:CharaImageData){
        //sksファイルでキャラ画像の位置がわかりやすいように色をつけていた場合、色を消す
        (aNode as! SKSpriteNode).color=UIColor(red:0,green:0,blue:0,alpha:0)
        //画像サイズを決定
        let tSize=(aNode as! SKSpriteNode).size
        let tHeightRatio=tSize.height/(tSize.width*3/2)
        
        for tParts in ["body","eye","mouth","accessory"]{
            //画像を表示するノードを取得
            var tPartsNode=aNode.childNode(withName:tParts) as? SKSpriteNode
            if(tPartsNode==nil){
                //画像を表示するノードがない
                tPartsNode=SKSpriteNode()
                tPartsNode!.size=(aNode as! SKSpriteNode).size
                tPartsNode!.name=tParts
                aNode.addChild(tPartsNode!)
            }
            //表示する画像を取得
            let tImage=aImageData.get(parts:tParts,pattern:"normal")
            if(tImage==nil){//画像がなかった
                (aNode.childNode(withName:tParts) as? SKSpriteNode)?.texture=nil//画像削除
                continue
            }
            //画像を表示
            if(tHeightRatio==1){//全体表示
                tPartsNode!.texture=SKTexture(image:tImage!)
            }
            else{//一部表示
                let tPartsImage=tImage!.cgImage!.cropping(to:
                    CGRect(x:0,
                           y:0,
                           width:400,
                           height:600*tHeightRatio))!
                tPartsNode!.texture=SKTexture(cgImage:tPartsImage)
            }
        }
    }
}
