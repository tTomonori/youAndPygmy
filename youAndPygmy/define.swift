//
//  define.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/13.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

let gEmptyFunction={()->()in}

//小数点以下取得
func decimal(aNum:Float)->Float{
    return aNum-floor(aNum)
}
//float + int
func + (left: Float, right: Int) -> Float{
    return left + Float(right)
}
//int + float
func + (left: Int, right: Float) -> Float{
    return Float(left) + right
}
//float * int
func * (left: Float, right: Int) -> Float{
    return left * Float(right)
}
//int + cgfloat
func + (left: Int, right: CGFloat) -> Float{
    return left + Float(right)
}
//cgpoint - cgpoint
func - (left:CGPoint,right:CGPoint)->CGPoint{
    return CGPoint(x:left.x-right.x,y:left.y-right.y)
}
//指定方向の逆向きを返す
func getReverseDirection(aDirection:String)->String{
    switch aDirection {
    case "up":return "down"
    case "down":return "up"
    case "left":return "right"
    case "right":return "left"
    default:print("逆方向がない方向だよ→",aDirection)
    }
    return "error"
}

//3d座標
struct FeildPosition{
    let x:Int
    let y:Int
    let z:Int
}

/*
 switch aDirection {
 case "up":
 case "down":
 case "left":
 case "right":
 default:print("不正な方向→",aDirection)
 }
 */

/*
 mScene=SKScene(fileNamed:"")
 //タップ時関数セット
 for tNode in mScene.children{
 if(tNode.name==nil){continue}
 switch tNode.name! {
 case "menu":
 default:break
 }
 }
*/
