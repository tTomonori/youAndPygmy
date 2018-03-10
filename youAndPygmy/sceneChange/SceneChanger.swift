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
}
