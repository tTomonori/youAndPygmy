//
//  PygmyMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/23.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmyMenu:Menu{
    static let singleton:PygmyMenu=PygmyMenu()
    private init(){
        super.init(aName:"pygmy")
    }
    override func createScene(){
        mScene=SKScene(fileNamed: "pygmyMenu")!
        //タップ時関数セット
        for tNode in mScene.children{
            let tName=(tNode.name != nil) ? tNode.name!:"label"
            switch tName {
                case "accompanying0":
                    tNode.accessibilityElements=["run",{()->()in print("0")}]
            default:
                tNode.accessibilityElements=["none"]
            }
        }
    }
    override func renew(){
        let tPygmies=You.getAccompanying()
        for i in 0..<5{
            let tNode=mScene.childNode(withName:"accompanying"+String(i))!.childNode(withName:"info")!
            let tCover=mScene.childNode(withName:"accompanying"+String(i))!.childNode(withName:"cover")!
            if(i<tPygmies.count){
                tCover.alpha=0
                let tPygmy=tPygmies[i]
                //キャライラスト
                let tImage=tNode.childNode(withName:"image")!
                (tImage.childNode(withName:"body") as! SKSpriteNode).texture
                    = SKTexture(imageNamed:tPygmy.getRaceData().key+"_body")
                (tImage.childNode(withName:"eye") as! SKSpriteNode).texture
                    = SKTexture(imageNamed:tPygmy.getRaceData().key+"_eye")
                (tImage.childNode(withName:"mouth") as! SKSpriteNode).texture
                    = SKTexture(imageNamed:tPygmy.getRaceData().key+"_mouth")
                //名前
                (tNode.childNode(withName:"name") as! SKLabelNode).text=tPygmy.getName()
                //レベル
                (tNode.childNode(withName:"level") as! SKLabelNode).text=String(tPygmy.getLevel())
                //元気
                StatusBarMaker.setGage(
                    aNode:tNode.childNode(withName:"hpBox")! as! SKSpriteNode,
                    aCurrent:tPygmy.getCurrentHp(),
                    aMax:tPygmy.getStatus().hp
                )
                //経験値
                StatusBarMaker.setGage(
                    aNode:tNode.childNode(withName:"experienceBox")! as! SKSpriteNode,
                    aCurrent:tPygmy.getExperience(),
                    aMax:tPygmy.getNextExperience()
                )
                //アイテム
                ItemBarMaker.setItemLabel(
                    aNode:tNode.childNode(withName:"itemBox")! as! SKSpriteNode,
                    aItem:tPygmy.getItem()
                )
                //アクセサリ
                ItemBarMaker.setAccessoryLabel(
                    aNode:tNode.childNode(withName:"accessoryBox")! as! SKSpriteNode,
                    aAccessory:tPygmy.getAccessory()
                )
            }
            else{
                //ぴぐみーがいない
                tNode.alpha=0
                tCover.alpha=1
            }
        }
    }
}
