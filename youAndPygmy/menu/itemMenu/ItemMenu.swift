//
//  ItemMenu.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/25.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation
import SpriteKit

class ItemMenu:Menu{
    static let singleton:ItemMenu=ItemMenu()
    var mItemBars:[SKNode]!
    var mShowingCategory:ItemCategory = .tool//表示しているアイテムのカテゴリ
    var mShowingBag:Bag!//表示しているバッグ
    var mLastPage:Int!//表示しているバッグのページ数
    var mShowingPage:Int=0//表示中のページ数
    var mLastPageNumNode:SKLabelNode!
    var mShowingPageNumNode:SKLabelNode!
    private init(){
        super.init(aName:"item")
    }
    override func createScene(){
        mScene=SKScene(fileNamed: "itemMenu")!
        var tBox:SKNode
        //カテゴリ変更
        tBox=mScene.childNode(withName:"categoryBars")!
        tBox.childNode(withName:"toolBar")!.setElement("tapFunction",{()->()in self.changeCategory(aCategory:.tool)})
        tBox.childNode(withName:"accessoryBar")!.setElement("tapFunction",{()->()in self.changeCategory(aCategory:.accessory)})
        tBox.childNode(withName:"importantBar")!.setElement("tapFunction",{()->()in self.changeCategory(aCategory:.important)})
        tBox.childNode(withName:"fragmentBar")!.setElement("tapFunction",{()->()in self.changeCategory(aCategory:.fragment)})
        //アイテム選択
        mItemBars=[]
        tBox=mScene.childNode(withName:"itemBars")!
        for i in 0...9{
            let tBar=tBox.childNode(withName:"itemBar"+String(i))!
            mItemBars.append(tBar)
            tBar.setElement("tapFunction",{()->()in
            })
        }
        //ページ切り替え
        tBox=mScene.childNode(withName:"pageChanger")!
        tBox.childNode(withName:"prePage")!.setElement("tapFunction",{()->()in
            self.showPrePage()
        })
        tBox.childNode(withName:"nextPage")!.setElement("tapFunction",{()->()in
            self.showNextPage()
        })
        mLastPageNumNode=tBox.childNode(withName:"lastPage")! as! SKLabelNode
        mShowingPageNumNode=tBox.childNode(withName:"nowPage")! as! SKLabelNode
        
    }
    override func renew() {
        let tItemList=mShowingBag.subList(at:10*mShowingPage,num:10)
        for i in 0...9{
            let tItem=tItemList[i]
            ItemBarMaker.setItemBar(aNode:mItemBars[i],aItem:tItem,aCategory:mShowingCategory)
        }
        mShowingPageNumNode.text=String(mShowingPage+1)
    }
    //表示するバッグ更新
    func renewBag(){
        mShowingBag=YouBag.getBag(mShowingCategory)
        mLastPage=Int(Double(mShowingBag.count())/10.0)+1
        mShowingPage=0
        mLastPageNumNode.text=String(mLastPage)
    }
    //表示するアイテムのカテゴリ変更
    func changeCategory(aCategory:ItemCategory){
        mShowingCategory=aCategory
        renewBag()
        renew()
    }
    //前のページ
    func showPrePage(){
        mShowingPage=(mShowingPage+mLastPage-1)%mLastPage
        renew()
    }
    //次のページ
    func showNextPage(){
        mShowingPage=(mShowingPage+1)%mLastPage
        renew()
    }
    override func firstDisplay() {
        renewBag()
    }
}
