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
    //マップを移動する時のアニメ
    static func animateChangeMap(aChanging:@escaping ()->(),aChanged:@escaping ()->()){
        let tScene=SKScene(fileNamed:"changeMap")!
        gGameViewController.set2dScene(aScene:tScene)
        tScene.children[0].run(SKAction.sequence([
            SKAction.moveBy(x: -750, y: 420, duration: 1.0),
            SKAction.run({()->()in aChanging()}),
            SKAction.moveBy(x: -750, y: 420, duration: 1.0),
            SKAction.run({()->()in aChanged()}),
            ]))
    }
    //戦闘開始時のアニメ
    static func animateEnterBattle(aChanging:@escaping ()->(),aChanged:@escaping ()->()){
        let tScene=SKScene(fileNamed:"enterBattle")!
        gGameViewController.set2dScene(aScene:tScene)
        let tFlashing=tScene.childNode(withName:"flashing")!
        let tCover=tScene.childNode(withName:"cover")!
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
}
