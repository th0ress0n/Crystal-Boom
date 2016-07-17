//
//  LevelScene.swift
//  Crystal Boom
//
//  Created by per thoresson on 18/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import SpriteKit


class LevelScene: SKScene {
    
    var nextBtn: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        nextBtn = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        nextBtn.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(nextBtn)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if nextBtn.containsPoint(location) {
                print("tapped!")
                
                let transition = SKTransition.fadeWithDuration(1.0)//SKTransition.revealWithDirection(.Down, duration: 1.0)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}