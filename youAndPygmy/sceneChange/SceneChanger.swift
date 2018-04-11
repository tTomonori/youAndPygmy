//
//  SceneChanger.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/22.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class SceneChanger{
    private static let mChangeMapScene=SKScene(fileNamed:"changeMap")!
    private static let mEnterBattleScene=SKScene(fileNamed:"enterBattle")!
    //マップを移動する時のアニメ
    static func animateChangeMap(aChanging:@escaping ()->(),aChanged:@escaping ()->()){
        gGameViewController.set2dScene(aScene:mChangeMapScene)
        mChangeMapScene.children[0].run(SKAction.sequence([
            SKAction.move(to:CGPoint(x:750,y:-420),duration:0),
            SKAction.moveBy(x: -750, y: 420, duration: 1.0),
            SKAction.run({()->()in aChanging()}),
            SKAction.moveBy(x: -750, y: 420, duration: 1.0),
            SKAction.run({()->()in aChanged()}),
            ]))
    }
    //戦闘開始時のアニメ
    static func animateEnterBattle(aChanging:@escaping ()->(),aChanged:@escaping ()->()){
        gGameViewController.set2dScene(aScene:mEnterBattleScene)
        let tFlashing=mEnterBattleScene.childNode(withName:"flashing")!
        let tCover=mEnterBattleScene.childNode(withName:"cover")!
        let tCoverSize=(tCover as! SKSpriteNode).size
        tFlashing.run(SKAction.sequence([
            SKAction.fadeAlpha(to:0.5,duration:0.2),
            SKAction.fadeOut(withDuration:0),
            SKAction.wait(forDuration:0.1),
            SKAction.fadeAlpha(to:0.5,duration:0.2),
            SKAction.fadeOut(withDuration:0),
            SKAction.wait(forDuration:0.1),
            SKAction.fadeAlpha(to:0.5,duration:0.2),
            SKAction.fadeOut(withDuration:0),
            SKAction.wait(forDuration:0.2),
            SKAction.run({()->()in
                tCover.run(SKAction.sequence([
                    SKAction.resize(toWidth:0,height:0,duration:0),
                    SKAction.fadeIn(withDuration:0),
                    SKAction.resize(toWidth:tCoverSize.width,height:tCoverSize.height,duration:0.7),
                    SKAction.run({()->()in aChanging()}),
                    SKAction.wait(forDuration:0.2),
                    SKAction.fadeOut(withDuration:0.4),
                    SKAction.run({()->()in aChanged()}),
                    ]))
            })
            ])
        )
    }
    private static let mOutScreen:SKSpriteNode=createBlackScreen()
    private static let mInScreen:SKSpriteNode=createBlackScreen()
    private static func createBlackScreen()->SKSpriteNode{
        let tNode=SKSpriteNode()
        tNode.size=gSceneSize
        tNode.color=UIColor(red:0,green:0,blue:0,alpha:1)
        tNode.setElement("tapEventType","block")
        tNode.name="blackOutScreen"
        return tNode
    }
    //ブラックアウト
    static func blackOut(aEndFunction:@escaping ()->()){
        if(mOutScreen.parent != nil){mOutScreen.removeFromParent()}
        mOutScreen.alpha=0
        gGameViewController.addOverlayNode(aNode:mOutScreen)
        mOutScreen.run(SKAction.sequence([
            SKAction.fadeIn(withDuration:1),
            SKAction.wait(forDuration:0.1),
            SKAction.run({
                aEndFunction()
            })
            ]))
    }
    //ブラックイン
    static func blackIn(aEndFunction:@escaping ()->()){
        if(mInScreen.parent != nil){mInScreen.removeFromParent()}
        mInScreen.alpha=1
        gGameViewController.addOverlayNode(aNode:mInScreen)
        mInScreen.run(SKAction.sequence([
            SKAction.wait(forDuration:0.1),
            SKAction.fadeOut(withDuration:1),
            SKAction.run({
                aEndFunction()
            })
            ]))
    }
}
