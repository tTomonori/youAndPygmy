import SpriteKit
import SceneKit
class Title{
    private
    static var mScene:SKScene!
    public
    //タイトル表示
    static func display(){
        mScene=SKScene(fileNamed: "title")!;
        for tNode in mScene.children{
            let tName=(tNode.name==nil) ? "":tNode.name!
            switch tName {
            case "screen":
                tNode.accessibilityElements=["run",{()->Void in Title.gameStart()}]
            default:
                tNode.accessibilityElements=["none"]
            }
        }
        gGameViewController!.set2dScene(aScene:mScene);
    }
    //タイトルを閉じる
    static func gameStart(){
//        gGameViewController!.set2dScene(aScene: gEmptySprite)
//        SaveData.load()
        SceneController.start()
    }
}
