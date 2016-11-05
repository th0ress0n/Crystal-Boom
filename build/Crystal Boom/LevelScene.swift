//
//  LevelScene.swift
//  Crystal Boom
//
//  Created by per thoresson on 18/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import SpriteKit
import SceneKit


class LevelScene: SKScene {
    
    var nextBtn: SKNode! = nil
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.blue;
        
        nextBtn = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        nextBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        
        self.addChild(nextBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if nextBtn.contains(location) {
                let transition = SKTransition.fade(withDuration: 1.0)//SKTransition.revealWithDirection(.Down, duration: 1.0)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
