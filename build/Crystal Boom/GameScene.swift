//
//  GameScene.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright (c) 2016 SAMBAVIKING. All rights reserved.
//

import SpriteKit
import SceneKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameon = false
    var isFingerDown = false
    var lastRow = false
    
    var objectsToRemove = [SKNode]()
    var location:CGPoint = CGPoint(x:0,y:0)
    var moveCount = 0
    var rowCount = 0
    var rowHeight:Int = 40 // set dynamically on level init
    var crystalWidth:CGFloat = 0 // set dynamically on init
    var levelratio = 0.5
    var shotcount = 0
    var shotInt = 2
    
    //
    
    var countdownTimer: Timer!
    
    // components
    var gun:cannon = cannon()
    var scoreBoard:ScoreBoard = ScoreBoard()
    
    override func didMove(to view: SKView) {
        gameScene = self
        
        crystalWidth = self.frame.size.width/8
        rowHeight = Int(crystalWidth*0.8) // fix this
        
        setupGameDefinitions()
        setupLevels()
        setupLayers()
        setupBg()
        addPhysicsdBorders()
        spawnCannon(cannonPosition)
        addScoreboard()
        currentLevel = levels[levelSelected]
        countdown()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 3.0)
    
    }
    
    
    func setupGameDefinitions(){
        
        crystalTypes.append(CrystalType(id:0, name:"AquaCrystal", texture:crystalOneTexture, health:2, points:320, size:crystalWidth , color:SKColor(red: 7.0/255.0, green: 191.0/255.0, blue: 215.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:1, name:"GreenCrystal", texture:crystalTwoTexture, health:3, points:480, size:crystalWidth, color:SKColor(red: 145.0/255.0, green: 39.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:2, name:"PinkCrystal", texture:crystalThreeTexture, health:4, points:630, size:crystalWidth, color:SKColor(red: 197.0/255.0, green: 65.0/255.0, blue: 104.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:3, name:"YellowCrystal", texture:crystalFourTexture, health:6, points:960, size:crystalWidth, color:SKColor(red: 255.0/255.0, green: 203.0/255.0, blue: 5.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:4, name:"RedTwoCrystal", texture:crystalFiveTexture, health:7, points:1250, size:crystalWidth, color:SKColor(red: 241.0/255.0, green: 91.0/255.0, blue: 64.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:5, name:"PurpleCrystal", texture:crystalSixTexture, health:9, points:1500, size:crystalWidth, color:SKColor(red: 145.0/255.0, green: 39.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:6, name:"AquaTwoCrystal", texture:crystalSevenTexture, health:11, points:1850, size:crystalWidth, color:SKColor(red: 53.0/255.0, green: 171.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:7, name:"RedCrystal", texture:crystalEightTexture, health:14, points:2500, size:crystalWidth, color:SKColor(red: 215.0/255.0, green: 25.0/255.0, blue: 32.0/255.0, alpha: 1.0)))
        
        // special types
        crystalTypes.append(CrystalType(id:8, name:"Bomb", texture:bombTexture, health:30, points:5000, size:crystalWidth, color:SKColor(red: 215.0/255.0, green: 25.0/255.0, blue: 32.0/255.0, alpha: 1.0)))
        
        crystalTypes.append(CrystalType(id:9, name:"Surprise", texture:surpriseTexture, health:30, points:5000, size:crystalWidth, color:SKColor(red: 215.0/255.0, green: 25.0/255.0, blue: 32.0/255.0, alpha: 1.0)))

    }
    
   
    func countdown(){
        // create visual countdown to prepare player
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(animateCountdown), userInfo: nil, repeats: true)
        
        startGame()
    }
    
    func animateCountdown(){
        
    }
    
    
    func startGame(){
        // set level specs
        scoreBoard.setLevel(currentLevel.id)
        scoreBoard.setMulti(currentMulti)
        
        
        spawnRow()
        gameon = true
    }
    
    func addScoreboard(){
        scoreBoard.position = CGPoint( x:screenSize.width/2, y:screenSize.height)
        hudLayer.addChild(scoreBoard)
    }
    
    
    func spawnRow(){
        if rowCount < currentLevel.data.count{
            for (index, gem) in currentLevel.data[rowCount].enumerated() { spawnCrystal(CGFloat(index),gemID: Int(gem as! NSNumber))}
            rowCount = rowCount+1
        }else{
            lastRow = true
            print("Last row Spawned!!!!")
        }
    }
    
    func getTypeForID(_ id:Int) -> CrystalType { return crystalTypes[id] }
    
    
    func shootBullet() {
        let shot = bullet()
        shot.name = "bullet"
        shot.position = CGPoint( x:self.size.width*0.5,y:  20)
        objectsLayer.addChild(shot)
        
        shot.physicsBody?.applyImpulse(CGVector(dx: (0.8) * (location.x - shot.position.x), dy: (0.8) * (location.y - shot.position.y)), at: CGPoint(x: position.x,y: position.y));
    }
    
    func addPhysicsdBorders(){
        let sceneFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height+200)
        let borderBody = SKPhysicsBody(edgeLoopFrom: sceneFrame)
        borderBody.friction = 0
        borderBody.categoryBitMask = bitMasks.BorderCategory
        borderBody.collisionBitMask = bitMasks.BulletCategory
        borderBody.contactTestBitMask = bitMasks.BulletCategory
        self.name = "border"
        self.physicsBody = borderBody
    }
    
    
    func spawnCannon(_ at: CGPoint) {
        gun.position = at
        objectsLayer.addChild(gun)
    }
    
    func spawnCrystal(_ index: CGFloat, gemID: Int) {
        let pt = CGPoint(x:(crystalWidth*index)+(crystalWidth*0.5) ,y:frameH*1.1 )
        let gem = crystal()
        gem.setup(crystalTypes[gemID])
        gem.position = pt
        gemLayer.addChild(gem)
    }
    
    
    func setupLayers() {
        objectsLayer = SKNode()
        objectsLayer.name = "Objects Layer"
        addChild(objectsLayer)
        
        gemLayer = SKNode()
        gemLayer.name = "Gem Layer"
        addChild(gemLayer)
        
        effectLayer = SKNode()
        effectLayer.name = "Effect Layer"
        addChild(effectLayer)
        
        hudLayer = SKNode()
        hudLayer.zPosition = 20
        hudLayer.name = "Hud Layer"
        addChild(hudLayer)
        
        modalLayer = SKNode()
        modalLayer.zPosition = 30
        modalLayer.name = "Modal Layer"
        addChild(modalLayer)
    }
    
    func setupBg() {
        let bg = SKSpriteNode(texture: texturesBg, color: UIColor.black, size: CGSize(width: frameW, height: frameH))
        bg.position = CGPoint(x: frameW / 2, y: frameH / 2)
        bg.zPosition = layers.background
        self.addChild(bg)
    }
    
    
    func getCrystalSpawnPosition(_ id:Int) -> CGPoint{
        return CGPoint(x: frameW*0.5, y: frameH*0.9)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == bitMasks.BulletCategory && secondBody.categoryBitMask == bitMasks.BorderCategory {
            if firstBody.node!.position.y > self.size.height-100 {
                self.objectsToRemove.append(firstBody.node!) // cleanup bullet
            }
        }
        
        if firstBody.categoryBitMask == bitMasks.CrystalCategory && secondBody.categoryBitMask == bitMasks.BorderCategory {
            print("Crystal colided with border at: ",firstBody.node!.position.y)
        }
        
        
        if firstBody.categoryBitMask == bitMasks.BulletCategory && secondBody.categoryBitMask == bitMasks.CrystalCategory {
            self.objectsToRemove.append(firstBody.node!) // cleanup bullet
            let ct = secondBody.node as! crystal
            let status = ct.takeDamage(1) // remove health from crystal
//            print("health : "+String(ct.healthPoints)+"     scorePoints : "+String(ct.scorePoints))
            if status == 0 {
                
                if ct.vo?.typeName == "Surprise" { // test for specific kind of object
                    // trigger Surprise
                    currentMulti = currentMulti + 1
                    scoreBoard.setMulti(currentMulti) // Set the multiplier
                }else if ct.vo?.typeName == "Bomb" {
                    currentMulti = 1
                    scoreBoard.setMulti(currentMulti) // Set the multiplier
                    triggerBomb(_triggerPoint: CGPoint(x: ct.position.x,y: ct.position.y)) // trigger Bomb
                    
                }else{
                    explosion(CGPoint(x: ct.position.x,y: ct.position.y), col: ct.vo!.colorValue)
                }
                
                
                self.objectsToRemove.append(ct)
                print("ADDING TO SCORE ",String(ct.scorePoints))
                
                
                
                scoreBoard.addPoints(ct.scorePoints)
                
                
            }
        }
    }
    
    func getDistance(_trigger:CGPoint, _item:CGPoint) -> CGFloat {
        let xDist = _trigger.x - _item.x
        let yDist = _trigger.y - _item.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    
    func triggerBomb(_triggerPoint:CGPoint){
        var bombScore:Int = 0
        
        for child in gemLayer.children {
            let itm:crystal = child as! crystal
            let crt = itm 
            let dist:CGFloat = getDistance(_trigger: _triggerPoint, _item: child.position)
            if dist < frameW*0.5  {
                bombScore = bombScore + crt.scorePoints                     // Add to score for explosion
                explosion(child.position, col: crt.vo!.colorValue)          // Add Explosion
                self.objectsToRemove.append(crt)                            // remove item
            }
        }
        scoreBoard.addPoints(bombScore)
        print("The BombScore : ",bombScore)
    }
    
    func explosion(_ pos: CGPoint, col:SKColor) {
//        print("MAKE EXPLOSION")
        let emitterNode = SKEmitterNode(fileNamed: "Explosion.sks")
        emitterNode!.particleColorSequence = nil;
        emitterNode!.particleColorBlendFactor = 1.0;
        emitterNode!.particleColor = col
        let effectNode = SKEffectNode()
        effectNode.zPosition = 20
        emitterNode!.particlePosition = pos
        effectNode.addChild(emitterNode!)
        self.addChild(effectNode)
        self.run(SKAction.wait(forDuration: 2), completion: {   // Don't forget to remove the emitter node after the explosion
//            print("removing explosion")
            emitterNode!.removeFromParent()
        })
        
    }
    
    // Modal handling ----------------------
    
    func showSettings(){
        
    }
    
    func hideSettings(){
    
    }
    
    func showHighscore(){
        
    }
    
    func hideHighscore(){
        
    }
    
    func showInfo(){
        
    }
    
    // -------------------------------------
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let tY = (touchLocation.y<bulletSwipeYMin) ? bulletSwipeYMin : touchLocation.y
        location = CGPoint(x: touchLocation.x, y:tY)
        let angle = atan2(20 - location.y, self.size.width*0.5 - location.x)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(Double.pi*0.5), duration: 0.0)
        gun.run(rotateAction)
        isFingerDown = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let tY = (touchLocation.y<bulletSwipeYMin) ? bulletSwipeYMin : touchLocation.y
        location = CGPoint(x: touchLocation.x, y:tY)
        let angle = atan2(20 - location.y, self.size.width*0.5 - location.x)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(Double.pi*0.5), duration: 0.0)
        gun.run(rotateAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){ isFingerDown = false }
    
    func cleaning() {
        objectsLayer.removeChildren(in: objectsToRemove)
        gemLayer.removeChildren(in: objectsToRemove)
    }
    
    override func update(_ currentTime: TimeInterval) {
        cleaning()
        if isFingerDown {
            shotcount = shotcount + 1
            if shotcount == shotInt{
                shootBullet()
                shotcount = 0
            }
        }
        
        if gameon{
            for child in gemLayer.children {
                let pos = child.position as CGPoint
                let yPos = pos.y-CGFloat(gameSpeed)
                child.position = CGPoint(x:pos.x, y:yPos)
            }
            if !lastRow {
                moveCount = moveCount+Int(gameSpeed)
                if moveCount >= rowHeight{
                    spawnRow()
                    moveCount = 0
                }
            }
            
        }
        
    }
    
    // Settup the level data here.
    
    func setupLevels(){
        // if already in memory, dont setup again
        if levels.count == 0 {
            
            // Level 1
            levels.append(Level(id:1,data:[[0,0,2,7,7,2,9,0],[1,8,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 2
            levels.append(Level(id:2,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 3
            levels.append(Level(id:3,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 4
            levels.append(Level(id:4,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 5
            levels.append(Level(id:5,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 6
            levels.append(Level(id:6,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 7
            levels.append(Level(id:7,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 8
            levels.append(Level(id:8,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 9
            levels.append(Level(id:9,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
        }
        
        
    }
    
    

}
