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
}
