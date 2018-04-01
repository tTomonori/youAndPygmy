//
//  GameViewController.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/02/01.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import UIKit
import QuartzCore
import SpriteKit
import SceneKit

var gGameViewController:GameViewController!
//画面のサイズ
var gScreenSize: CGSize = UIScreen.main.bounds.size

var gEmptySprite=SKScene()
var gEmptyScene=SCNScene()
class GameViewController: UIViewController {
    //ユーザの操作を受け付けるか
    private var mUserOperationRight:Bool=false
    //main関数
    override func viewDidLoad() {
        super.viewDidLoad()
        //タップ時に実行する関数セット
        let tTapGesture=UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tTapGesture)
        //パン(ドラッグ)時に実行する関数セット
        let tPanGesture=UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(tPanGesture)
        //カメラ操作許可(許可するとPanイベントが取れなくなる)
//        (self.view as! SCNView).allowsCameraControl=true
//        (self.view as! SCNView).showsStatistics = true
        
        self.set2dScene(aScene: gEmptySprite)
        self.set3dScene(aScene: gEmptyScene)
        gGameViewController=self;
        SceneController.didLoad()
    }
    
    //タップした時
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if(mUserOperationRight==false){return}
        let tView=self.view as! SCNView;
        let tPoint=gestureRecognize.location(in: tView);
        if(tView.overlaySKScene != nil){
            //2dシーン
            let t2dSize=tView.overlaySKScene!.size
            let tX=(tPoint.x/gScreenSize.width-0.5)*(t2dSize.width)
            let tY = -(tPoint.y/gScreenSize.height-0.5)*(t2dSize.height)
            let t2dPoint=CGPoint(x:tX,y:tY)//3d座標を2d座標に変換
            let tScene=tView.overlaySKScene!;
            let tNodes=tScene.nodes(at: t2dPoint);
            for tNode in tNodes{
                if let tFunction=tNode.getAccessibilityElement("tapFunction"){
                    (tFunction as! ()->())()//タップ関数実行
                    return
                }
                let tEventType=tNode.getAccessibilityElement("tapEventType")
                if(tEventType as? String=="block"){return}
            }
        }
        if(tView.scene != nil){
            //3dシーン
            let tObjects=tView.hitTest(tPoint);
            for tObject in tObjects{
                if let tFunction=tObject.node.getAccessibilityElement("tapFunction"){
                    (tFunction as! ()->())()//タップ関数実行
                    return
                }
                let tEventType=tObject.node.getAccessibilityElement("tapEventType")
                if(tEventType as? String=="block"){return}
            }
        }
    }
    //パン(ドラッグ)した時
    func handlePan(_ gestureRecognize: UIGestureRecognizer){
        PanOperator.pan(aRecognizer:gestureRecognize)
        if(mUserOperationRight==false){return}
        //2dシーン
        if let t2dScene=(self.view as! SCNView).overlaySKScene{
            if let tFunction=t2dScene.getAccessibilityElement("dragFunction"){
                (tFunction as! ((UIGestureRecognizer)->()))(gestureRecognize)
                return
            }
        }
        //3dシーン
        if let t3dScene=(self.view as! SCNView).scene{
            if let tFunction=t3dScene.accessibilityElements?[0]{
                (tFunction as! ((UIGestureRecognizer)->()))(gestureRecognize)
                return
            }
        }
    }

    //3Dシーンセット
    func set3dScene(aScene:SCNScene){
        //描画更新させ続けるためにノード追加
        let tBox=SCNNode()
        tBox.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        aScene.rootNode.addChildNode(tBox)
        
        (self.view as! SCNView).scene=aScene
    }
    //2Dシーンセット
    func set2dScene(aScene:SKScene){
        (self.view as! SCNView).overlaySKScene=aScene
        (self.view as! SCNView).overlaySKScene!.scaleMode = .aspectFill
    }
    //2Dシーン取得
    func get2dScene()->SKScene{return (self.view as! SCNView).overlaySKScene!}
    //2Dシーンにノード追加
    func addOverlayNode(aNode:SKNode){
        (self.view as! SCNView).overlaySKScene!.addChild(aNode)
    }
    //uialert表示
    func showAlert(aAlertController:UIAlertController){
        present(aAlertController, animated: true, completion: nil)
    }
    //ユーザの操作を許可する
    func allowUserOperate(){
        mUserOperationRight=true
    }
    //ユーザの操作を拒否する
    func denyUserOperate(){
        mUserOperationRight=false
    }
    //2d座標を取得
    func get2dPoint(_ gestureRecognize: UIGestureRecognizer)->CGPoint{
        let tView=self.view as! SCNView;
        let tPoint=gestureRecognize.location(in: tView);
        let t2dSize=tView.overlaySKScene!.size
        let tX=(tPoint.x/gScreenSize.width-0.5)*(t2dSize.width)
        let tY = -(tPoint.y/gScreenSize.height-0.5)*(t2dSize.height)
        let t2dPoint=CGPoint(x:tX,y:tY)//3d座標を2d座標に変換
        return t2dPoint
    }
    //2dシーンのノード取得
    func get2dNodes(aPoint:CGPoint)->[SKNode]{
        let tView=self.view as! SCNView;
        let tScene=tView.overlaySKScene!;
        let tNodes=tScene.nodes(at:aPoint);
        return tNodes
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
