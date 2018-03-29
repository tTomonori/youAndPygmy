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
            let tImageName=aImageData.get(parts:tParts,pattern:"normal")
            if(tImageName==nil){//画像がなかった
                (aNode.childNode(withName:tParts) as? SKSpriteNode)?.texture=nil//画像削除
                continue
            }
            var tPartsNode=aNode.childNode(withName:tParts) as? SKSpriteNode
            if(tPartsNode==nil){
                //画像を表示するノードがない
                tPartsNode=SKSpriteNode()
                tPartsNode!.size=(aNode as! SKSpriteNode).size
                tPartsNode!.texture=SKTexture(imageNamed:tImageName!)
                tPartsNode!.name=tParts
                aNode.addChild(tPartsNode!
                )
            }
            //画像を表示
            if(tHeightRatio==1){//全体表示
                tPartsNode!.texture=SKTexture(imageNamed:tImageName!)
            }
            else{//一部表示
                let tOriginalImage=UIImage(named:tImageName!)!
                let tImage=tOriginalImage.cgImage!.cropping(to:
                    CGRect(x:0,
                           y:0,
                           width:400,
                           height:600*tHeightRatio))
                tPartsNode!.texture=SKTexture(cgImage:tImage!)
            }
        }
    }
}
