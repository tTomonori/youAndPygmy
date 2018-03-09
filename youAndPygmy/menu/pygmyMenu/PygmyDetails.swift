//
//  StatusDetails.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/02.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class PygmyDetails:Menu{
    static let singleton:PygmyDetails=PygmyDetails()
    private init(){
        super.init(aName:"details")
    }
    override func createScene(){
        mScene=SKScene(fileNamed: "pygmyDetails")!
        //タップ時関数セット
        mScene.childNode(withName:"skillBox")!.accessibilityElements=["run",{()->()in print("skillBox")}]
        mScene.childNode(withName:"statusBox")!.childNode(withName:"changeButton")!.accessibilityElements =
            ["run",{()->()in
                self.changeStatusDisplayMode()
                }]
    }
    override func renew(aOptions: Dictionary<String, Any>) {
        let tPygmies=You.getAccompanying()
        let tPygmy=tPygmies[aOptions["accompanyingNum"] as! Int]
        //画像
        PygmyImageMaker.setImage(aNode:mScene.childNode(withName:"image")!,aImageData:tPygmy.getImage())
        //キャラ基本情報
        let tInfo=mScene.childNode(withName:"infoBox")!
        //名前
        (tInfo.childNode(withName:"name") as! SKLabelNode).text=tPygmy.getName()
        //種族名
        (tInfo.childNode(withName:"raceName") as! SKLabelNode).text=tPygmy.getRaceData().raceName
        //レベル
        (tInfo.childNode(withName:"level") as! SKLabelNode).text=String(tPygmy.getLevel())
        //hp
        StatusBarMaker.setGage(aNode:(tInfo.childNode(withName:"hpBox") as! SKSpriteNode),
                               aCurrent:tPygmy.getCurrentHp(),aMax:tPygmy.getStatus().hp)
        //経験値
        StatusBarMaker.setGage(aNode:(tInfo.childNode(withName:"experienceBox") as! SKSpriteNode),
                               aCurrent:tPygmy.getExperience(),aMax:tPygmy.getNextExperience())
        //持ち物
        ItemBarMaker.setItemLabel(aNode:(tInfo.childNode(withName:"itemBox") as! SKSpriteNode),
                                  aItem:tPygmy.getItem())
        //アクセサリ
        ItemBarMaker.setAccessoryLabel(aNode:(tInfo.childNode(withName:"accessoryBox") as! SKSpriteNode),
                                       aAccessory:tPygmy.getAccessory())
        
        //スキル
        let tSkillBox=mScene.childNode(withName:"skillBox")!
        //装備スキル
        SkillBarMaker.setSettedSkillsList(aNode:tSkillBox.childNode(withName:"settedSkills") as! SKSpriteNode,
                                   aSkills:tPygmy.getSettedSkills())
        //習得スキル
        SkillBarMaker.setMasteredSkillsList(aNode:tSkillBox.childNode(withName:"masteredSkills") as! SKSpriteNode,
                                   aSkills:tPygmy.getMasteredSkills())
        
        //ステータス
        let tStatusBox=mScene.childNode(withName:"statusBox")!
        //強さ
        StatusDisplayer.setDisplay(aNode:tStatusBox.childNode(withName:"strongBox") as! SKSpriteNode,
                                   aStatus:tPygmy.getStatus(),
                                   aCorrection:tPygmy.getCorrection(),
                                   aAddCorrection:false)
        //移動力
        StatusDisplayer.setMobilityDisplay(aNode:tStatusBox.childNode(withName:"mobilityBox") as! SKSpriteNode,
                                           aMobility:tPygmy.getRaceData().mobility)
    }
    //ステータス表示,移動力表示を切り替える
    func changeStatusDisplayMode(){
        let tStrongBox=mScene.childNode(withName:"statusBox")!.childNode(withName:"strongBox")!
        let tMobilityBox=mScene.childNode(withName:"statusBox")!.childNode(withName:"mobilityBox")!
        
        tStrongBox.alpha=1-tStrongBox.alpha
        tMobilityBox.alpha=1-tMobilityBox.alpha
    }
}
