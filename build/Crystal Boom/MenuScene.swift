//
//  MenuScene.swift
//  Crystal Boom
//
//  Created by per thoresson on 18/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import SpriteKit


class MenuScene: SKScene {
    
    var playBtn: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        playBtn = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        playBtn.name = "playBtn"
        playBtn.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(playBtn)
    }
    
    func open() -> Void {
        print("open")
        let scene = LevelScene(fileNamed: "LevelScene")!
        let transition = SKTransition.moveInWithDirection(.Right, duration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            print("touchedNode.name ",touchedNode.name)
            
            if touchedNode.name == "playBtn" {
                let transition = SKTransition.fadeWithDuration(1.0)//SKTransition.revealWithDirection(.Down, duration: 1.0)
                
                let nextScene = LevelScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}