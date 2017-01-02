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
    
    var playBtn: SKSpriteNode! = nil
    var highscoreBtn: SKSpriteNode! = nil
    var infoBtn: SKSpriteNode! = nil
    var settingsBtn: SKSpriteNode! = nil
    
    var logo: SKSpriteNode! = nil
    var playBtnImg: SKSpriteNode! = nil
    
    var modalBGimg: SKSpriteNode! = nil
    var modalCloseimg: SKSpriteNode! = nil
    var modalToggleOnimg: SKSpriteNode! = nil
    var modalToggleOffimg: SKSpriteNode! = nil
    
    
    override func didMove(to view: SKView) {
        menuScene = self;
        setupBg();
        addLogo();
        addNav();
    }
    
    
    func addLogo() {
        logo = SKSpriteNode(texture: textureLogo)
        let logowidth = screenSize.width*0.7
        let logoWidthRatio = ( logowidth / logo.size.width);
        print("logo ",logoWidthRatio)
        logo.size.width = logowidth
        logo.size.height = logo.size.height * logoWidthRatio
        logo.position = CGPoint(x:self.frame.midX, y:self.frame.midY * 1.5);
        logo.zPosition = layers.navigation
        self.addChild(logo)
    }
    
    func addNav() {
        
        playBtn = SKSpriteNode(texture: homePlayBtn)
        let playBtnRatio = (screenSize.width*0.55) / playBtn.size.width
        playBtn.size.width = (screenSize.width*0.55)
        playBtn.size.height = playBtn.size.height * playBtnRatio
        playBtn.name = "playBtn"
        playBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        playBtn.zPosition = layers.navigation;
        self.addChild(playBtn);
        
        
        
        infoBtn = SKSpriteNode(texture: homeInfoBtn)
        infoBtn.size.width = (screenSize.width*0.15)
        infoBtn.size.height = infoBtn.size.width
        infoBtn.name = "infoBtn"
        infoBtn.position = CGPoint(x:self.frame.midX-(infoBtn.size.width*1.2), y:self.frame.midY - 65);
        infoBtn.zPosition = layers.navigation;
        self.addChild(infoBtn);
        
        highscoreBtn = SKSpriteNode(texture: homeHighscoreBtn)
        highscoreBtn.size.width = (screenSize.width*0.15)
        highscoreBtn.size.height = highscoreBtn.size.width
        highscoreBtn.name = "highscoreBtn"
        highscoreBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 65);
        highscoreBtn.zPosition = layers.navigation;
        self.addChild(highscoreBtn);
        
        settingsBtn = SKSpriteNode(texture: homeSettingsBtn)
        settingsBtn.size.width = (screenSize.width*0.15)
        settingsBtn.size.height = settingsBtn.size.width
        settingsBtn.name = "settingsBtn"
        settingsBtn.position = CGPoint(x:self.frame.midX+(settingsBtn.size.width*1.2), y:self.frame.midY - 65);
        settingsBtn.zPosition = layers.navigation;
        self.addChild(settingsBtn);
        
    }
    
    
    
    func setupBg() {
        let bg = SKSpriteNode(texture: texturesHomeBg, color: UIColor.black, size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
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
            
            // play game
            if touchedNode.name == "playBtn" {
                let transition = SKTransition.fade(withDuration: 1.0)//SKTransition.revealWithDirection(.Down, duration: 1.0)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
            
            // Settings Screen
            if touchedNode.name == "settingsBtn" {
                print("Open settings screen")
                
            }
            
            // Info Screen
            if touchedNode.name == "infoBtn" {
                print("Open info screen")
                
            }
            
            
            // Highscore Screen
            if touchedNode.name == "highscoreBtn" {
                print("Open highscore screen")
                
            }
            
        }
    }
    
    func openModal(type:String){
        modalBGimg = SKSpriteNode(texture: modalBGMed)
        modalCloseimg = SKSpriteNode(texture: modalCloseBtn)
        modalToggleOnimg = SKSpriteNode(texture: modalToggleOn)
        modalToggleOffimg = SKSpriteNode(texture: modalToggleOff)
        
        switch type {
            case "settings":
                // --
                break;
            case "info":
                // --
                break;
            case "highscore":
                // --
                break;
            default:
                // -
                break;
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
