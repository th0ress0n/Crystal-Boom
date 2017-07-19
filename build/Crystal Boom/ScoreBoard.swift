//
//  ScoreBoard.swift
//  Crystal Boom
//
//  Created by per thoresson on 14/11/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class ScoreBoard: SKNode{
    
    var total:Int = 0
    var multiply:Int = 0
    // animator
    var interval:Int = 200
    var fromVal:Int = 0
    var targetVal:Int = 0
    var animateTimer: Timer!
    
    var levelLabel:SKLabelNode!
    var scoreLabel:SKLabelNode!
    var multiLabel:SKLabelNode!
    
    var currentLevel = 0
    
    var multiplier = 1
    
    override init() {
        super.init()   //  initialize the default values from the SuperClass ( character )
        setup();
    }
    
    func setup(){
        
        let hudbg = SKSpriteNode(texture: textureHUD)
        let widthRatio = (screenSize.width / hudbg.size.width);
        hudbg.size.width = screenSize.width
        hudbg.size.height = hudbg.size.height * widthRatio
        hudbg.position.y = -hudbg.size.height*0.5
        self.addChild(hudbg)
        
        levelLabel = SKLabelNode(fontNamed: "KomikaAxis")
        levelLabel.text = "12"
        levelLabel.fontSize = 28
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelLabel.color = SKColor.white
        levelLabel.position = CGPoint(x:-screenSize.width*0.39, y:-hudbg.size.height*0.7)
        levelLabel.zPosition = 30
        self.addChild(levelLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "KomikaAxis")
        scoreLabel.text = "0000000000"
        scoreLabel.fontSize = 28
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.color = SKColor.white
        scoreLabel.position = CGPoint(x:0, y:-hudbg.size.height*0.7)
        scoreLabel.zPosition = 30
        self.addChild(scoreLabel)
        
        multiLabel = SKLabelNode(fontNamed: "KomikaAxis")
        multiLabel.text = "12"
        multiLabel.fontSize = 28
        multiLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        multiLabel.color = SKColor.white
        multiLabel.position = CGPoint(x:screenSize.width*0.39, y:-hudbg.size.height*0.7)
        multiLabel.zPosition = 30
        self.addChild(multiLabel)
    }
    
    
    // POINTS ----------------
    
    func addPoints(_ point: Int) {
        print("Points added ",point)
        targetVal = targetVal + (point*currentMulti)
        animateIncrement()
    }
    
    func removePoints(point:Int){
        targetVal = targetVal - point
        animateIncrement()
    }
    
    func animateIncrement(){
        animateTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(showAnimatedValue), userInfo: nil, repeats: true)
    }
    
    // -----------------------
    
    
    // LEVEL -----------------
    
    func setLevel(_ level: Int){
        print("Setting Level to: ",level)
        currentLevel = level
        levelLabel.text = String(currentLevel)
    }
    
    // -----------------------
    
    
    
    // MULTIPLIER ------------
    func setMulti(_ multi: Int){
        multiplier = multi
        multiLabel.text = String(multiplier)
    }
    // -----------------------
    
    
    func showAnimatedValue(){
        if total < targetVal {
            let hplus = (targetVal-total)/10
            if hplus < 1 {
                total = targetVal
            }else{
                total = Int(ceil(Double(total + hplus)))
            }
        }
        if total > targetVal {
            let hmin = (total-targetVal)/10
            if hmin < 1 {
                total = targetVal
            }else{
                total = Int(ceil(Double(total - hmin)))
            }
        }
        let scoreStr = String(total)
        let scorelength = scoreStr.characters.count
        var output = ""
        while output.characters.count < (10-scorelength) { output += "0" }
        output += scoreStr
        scoreLabel.text = output
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
