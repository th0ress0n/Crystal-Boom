//
//  MenuScene.swift
//  Crystal Boom
//
//  Created by per thoresson on 18/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import SpriteKit
import SceneKit


class MenuScene: SKScene {
    
    var playBtn: SKNode! = nil
    var highscoreBtn: SKNode! = nil
    
    override func didMove(to view: SKView) {
        menuScene = self;
        setupBg();
        addNav();
    }
    
    
    func addNav() {
        
        playBtn = SKSpriteNode(color: SKColor.red, size: CGSize(width: 140, height: 35))
        playBtn.name = "playBtn"
        playBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        playBtn.zPosition = layers.navigation;
        self.addChild(playBtn);
        
        highscoreBtn = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 140, height: 35))
        highscoreBtn.name = "highscoreBtn"
        highscoreBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        highscoreBtn.zPosition = layers.navigation;
        self.addChild(highscoreBtn);
        
        
    }
    
    
    
    func setupBg() {
        let bg = SKSpriteNode(texture: texturesBg, color: UIColor.black, size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        bg.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        bg.zPosition = layers.background
        self.addChild(bg)
    }
    
    
    
    func open() -> Void {
        let scene = LevelScene(fileNamed: "LevelScene")!
        let transition = SKTransition.moveIn(with: .right, duration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            print("touchedNode.name ",touchedNode.name);
//            if touchedNode.name == "playBtn" {
//                let transition = SKTransition.fade(withDuration: 1.0)//SKTransition.revealWithDirection(.Down, duration: 1.0)
//                
//                let nextScene = LevelScene(size: scene!.size)
//                nextScene.scaleMode = .aspectFill
//                scene?.view?.presentScene(nextScene, transition: transition)
//            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
