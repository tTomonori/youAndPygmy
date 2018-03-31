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
    var mDetails:SKNode!
    var mShowingCategory:ItemCategory = .tool//表示しているアイテムのカテゴリ
    var mShowingBag:Bag!//表示しているバッグ
    var mLastPage:Int!//表示しているバッグのページ数
    var mShowingPage:Int=0//表示中のページ数
    var mLastPageNumNode:SKLabelNode!
    var mShowingPageNumNode:SKLabelNode!
    var mBarImageName:String!
    var mSelectedItem:String?//選択されているアイテム
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
        //詳細欄
        mDetails=mScene.childNode(withName:"detailsBox")!
        mDetails.childNode(withName:"itemDetails")!.alpha=0
        //アイテム選択
        mItemBars=[]
        tBox=mScene.childNode(withName:"itemBars")!
        for i in 0...9{
            let tBar=tBox.childNode(withName:"itemBar"+String(i))!
            mItemBars.append(tBar)
            tBar.setElement("tapFunction",{()->()in
                let tKey=tBar.getAccessibilityElement("itemKey") as! String
                if(tKey==self.mSelectedItem){
                    //アイテム選択
                    self.selectItem()
                }
                else{
                    //詳細説明表示
                    self.mSelectedItem=tKey
                    self.showDetails()
                }
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
        //アイテムのバーの画像名
        mBarImageName=BarMaker.getBackgroundName(aNode:mItemBars[0])
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
        changeBarColor(aCategory:aCategory)
        mSelectedItem=nil
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
    //アイテムのバーの色変更
    func changeBarColor(aCategory:ItemCategory){
        var tColor:String
        switch aCategory {
        case .tool://どうぐ
            tColor="green"
        case .accessory://アクセサリ
            tColor="yellow"
        case .important://大切なもの
            tColor="purple"
        case .fragment://カケラ
            tColor="blue"
        }
        for tBar in mItemBars{
            BarMaker.setBarImage(aNode:tBar.childNode(withName:"background")!,aBarName:tColor+mBarImageName)
        }
    }
    //アイテムの説明表示
    func showDetails(){
        switch mShowingCategory {
        case .tool://どうぐ
            let tBox=mDetails.childNode(withName:"itemDetails")!
            tBox.alpha=1
            let tData=ItemDictionary.get(mSelectedItem!)
            (tBox.childNode(withName:"name") as! SKLabelNode).text=tData.name
            (tBox.childNode(withName:"details") as! SKLabelNode).text=tData.text
        case .accessory://アクセサリ
            let tBox=mDetails.childNode(withName:"itemDetails")!
            tBox.alpha=1
            let tData=AccessoryDictionary.get(mSelectedItem!)
            (tBox.childNode(withName:"name") as! SKLabelNode).text=tData.name
            (tBox.childNode(withName:"details") as! SKLabelNode).text=tData.text
        case .important://大切なもの
            break
        case .fragment://カケラ
            break
        }
    }
    //アイテムを選択
    func selectItem(){
        switch mShowingCategory {
        case .tool:selectTool()
        case .accessory:selectAccessory()
        default:
            break
        }
    }
    func selectTool(){
        var tChoice:[String]=[]
        let tToolData=ItemDictionary.get(mSelectedItem!)
        if(tToolData.useEffect != nil){tChoice.append("使う")}
        if(tToolData.maxNum>0){tChoice.append("もたせる")}
        tChoice.append("やめる")
        MiniChoice.select(aChoice:tChoice,aFunction:{(aChoice)->()in
            switch aChoice{
            case "使う":ItemConsumer.use(aTool:self.mSelectedItem!,aEndFunction:{()->()in self.renew()})
            case "持たせる":ItemConsumer.toHave(aTool:self.mSelectedItem!,aEndFunction:{()->()in self.renew()})
            default:
                break
            }
        })
    }
    func selectAccessory(){
        MiniChoice.select(aChoice:["装備する","やめる"],aFunction:{(aChoice)->()in
            switch aChoice{
            case "装備する":ItemConsumer.equip(aAccessory:self.mSelectedItem!,aEndFunction:{()->()in self.renew()
            })
            default:
                break
            }
        })
    }
    override func firstDisplay() {
        mSelectedItem=nil
        mDetails.childNode(withName:"itemDetails")!.alpha=0
        renewBag()
    }
}
