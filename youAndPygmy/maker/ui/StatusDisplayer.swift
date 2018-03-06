//
//  StatusDisplayer.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/03.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class StatusDisplayer{
    static func setDisplay(aNode:SKSpriteNode,aStatus:Status,aCorrection:Status,aAddCorrection:Bool){
        let tStatusKey=["hp","mp","atk","def","ini","spt","dex","spd","pie"]
        for tKey in tStatusKey{
            let tBox=aNode.childNode(withName:tKey+"Box")!
            //補正値の色
            var tColor:UIColor
            let tDefaultColor=UIColor(red:0,green:0,blue:0,alpha:1)
            var tSignText="+"//補正値の符号
            if(aCorrection.get(key:tKey)==0){tColor=UIColor(red:0,green:0,blue:0,alpha:1)}
            else if(aCorrection.get(key:tKey)>0){tColor=UIColor(red:0,green:0,blue:255,alpha:1)}
            else{tColor=UIColor(red:255,green:0,blue:0,alpha:1);tSignText="-"}
            //実数値
            let tValue=tBox.childNode(withName:"value") as! SKLabelNode
            tValue.text=(aAddCorrection)
                ?String(aStatus.get(key:tKey)+aCorrection.get(key:tKey))
                :String(aStatus.get(key:tKey))
            tValue.color=(aAddCorrection) ? tColor : tDefaultColor
            //補正値
            let tCorrection=tBox.childNode(withName:"correctionValue") as! SKLabelNode
            tCorrection.text=String(abs(aCorrection.get(key:tKey)))
            tCorrection.color=tColor
            //補正値の符号
            let tSign=tBox.childNode(withName:"sign") as! SKLabelNode
            tSign.text=tSignText
            tSign.color=tColor
        }
    }
    static func setMobilityDisplay(aNode:SKSpriteNode,aMobility:Mobility){
        let tMobilityKey=["move","grass","sand","water","magma","snow","ice","air"]
        for tKey in tMobilityKey{
            let tBox=aNode.childNode(withName:tKey+"Box")!
            (tBox.childNode(withName:"value") as! SKLabelNode).text=(aMobility.get(key:tKey)<0)
                ?"-"
                :String(aMobility.get(key:tKey))
        }
    }
}
