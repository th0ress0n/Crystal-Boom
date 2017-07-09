//
//  SettingsScene.swift
//  Crystal Boom
//
//  Created by per thoresson on 16/01/2017.
//  Copyright © 2017 SAMBAVIKING. All rights reserved.
//

import SpriteKit
import SceneKit

class SettingsScene: SKScene {
    
    var modalBGimg: SKSpriteNode! = nil
    var modalCloseimg: SKSpriteNode! = nil
    var modalToggleOnimg: SKSpriteNode! = nil
    var modalToggleOffimg: SKSpriteNode! = nil
    
    
//    modalToggleOnimg = SKSpriteNode(texture: modalToggleOn)
//    modalToggleOffimg = SKSpriteNode(texture: modalToggleOff)
    
    
    override func didMove(to view: SKView) {
        settingsScene = self
        setupBg()
        addGraphics()
    }
    
    func setupBg(){
        let bg = SKSpriteNode(texture: texturesHomeBg, color: UIColor.black, size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        bg.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        bg.zPosition = layers.background
        self.addChild(bg)
    }
    
    func addGraphics(){
        
        modalBGimg = SKSpriteNode(texture: modalBGMed)
        modalCloseimg = SKSpriteNode(texture: modalCloseBtn)
        
        
        
        let modalBgWidth = screenSize.width*0.8
        let modalBgWidthRatio = ( modalBgWidth / modalBGimg.size.width);
        modalBGimg.size.width = modalBgWidth
        modalBGimg.size.height = modalBGimg.size.height * modalBgWidthRatio
        modalBGimg.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        modalBGimg.zPosition = layers.navigation
        self.addChild(modalBGimg)
        
        let modalCloseWidth = screenSize.width*0.15
        let modalCloseWidthRatio = ( modalCloseWidth / modalCloseimg.size.width);
        modalCloseimg.size.width = modalCloseWidth
        modalCloseimg.size.height = modalCloseimg.size.height * modalCloseWidthRatio
        modalCloseimg.position = CGPoint(x:self.frame.midX * 1.6, y:self.frame.midY * 1.52);
        modalCloseimg.zPosition = layers.navigation + 1
        modalCloseimg.name = "closeBtn"
        self.addChild(modalCloseimg)
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            // play game
            if touchedNode.name == "closeBtn" {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let nextScene = MenuScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }

    
    
    
    
}
