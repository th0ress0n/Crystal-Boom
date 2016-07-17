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
    var levelratio = 1
    
    var gun:cannon = cannon()
    
    override func didMoveToView(view: SKView) {
        gameScene = self
        
        crystalWidth = self.frame.size.width/8
        rowHeight = Int(crystalWidth)
        setupGameDefinitions()
        setupLevels()
        setupLayers()
        setupBg()
        addPhysicsdBorders()
        spawnCannon(cannonPosition)
        
        currentLevel = levels[levelSelected] 
        
        countdown()
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, 3.0)
    
    }
    
    
    func setupGameDefinitions(){
        
        crystalTypes.append(CrystalType(id:0, texture:crystalOneTexture, health:2, points:320, size:crystalWidth , color:SKColor(red: 7.0/255.0, green: 191.0/255.0, blue: 215.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:1, texture:crystalTwoTexture, health:4, points:480, size:crystalWidth, color:SKColor(red: 145.0/255.0, green: 39.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:2, texture:crystalThreeTexture, health:6, points:630, size:crystalWidth, color:SKColor(red: 197.0/255.0, green: 65.0/255.0, blue: 104.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:3, texture:crystalFourTexture, health:8, points:960, size:crystalWidth, color:SKColor(red: 255.0/255.0, green: 203.0/255.0, blue: 5.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:4, texture:crystalFiveTexture, health:10, points:1250, size:crystalWidth, color:SKColor(red: 241.0/255.0, green: 91.0/255.0, blue: 64.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:5, texture:crystalSixTexture, health:12, points:1500, size:crystalWidth, color:SKColor(red: 145.0/255.0, green: 39.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:6, texture:crystalSevenTexture, health:16, points:1850, size:crystalWidth, color:SKColor(red: 53.0/255.0, green: 171.0/255.0, blue: 143.0/255.0, alpha: 1.0)))
        crystalTypes.append(CrystalType(id:7, texture:crystalEightTexture, health:20, points:2500, size:crystalWidth, color:SKColor(red: 215.0/255.0, green: 25.0/255.0, blue: 32.0/255.0, alpha: 1.0)))

    }
    
   
    func countdown(){
        // create visual countdown to prepare player
        startGame()
    }
    
    
    func startGame(){
        spawnRow()
        gameon = true
    }
    
    
    func spawnRow(){
        if rowCount < currentLevel.data.count{
            for (index, gem) in currentLevel.data[rowCount].enumerate() { spawnCrystal(CGFloat(index),gemID: Int(gem as! NSNumber))}
            rowCount = rowCount+1
        }else{
            lastRow = true
        }
    }
    
    func getTypeForID(id:Int) -> CrystalType { return crystalTypes[id] }
    
    
    func shootBullet() {
        let shot = bullet()
        shot.name = "bullet"
        shot.position = CGPoint( x:self.size.width*0.5,y:  20)
        objectsLayer.addChild(shot)
        
        shot.physicsBody?.applyImpulse(CGVectorMake((0.8) * (location.x - shot.position.x), (0.8) * (location.y - shot.position.y)), atPoint: CGPointMake(position.x,position.y));
    }
    
    func addPhysicsdBorders(){
        let sceneFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height+200)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: sceneFrame)
        borderBody.friction = 0
        borderBody.categoryBitMask = bitMasks.BorderCategory
        borderBody.collisionBitMask = bitMasks.BulletCategory
        borderBody.contactTestBitMask = bitMasks.BulletCategory
        self.name = "border"
        self.physicsBody = borderBody
    }
    
    
    func spawnCannon(at: CGPoint) {
        gun.position = at
        objectsLayer.addChild(gun)
    }
    
    func spawnCrystal(index: CGFloat, gemID: Int) {
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
    }
    
    func setupBg() {
        let bg = SKSpriteNode(texture: texturesBg, color: UIColor.blackColor(), size: CGSize(width: frameW, height: frameH))
        bg.position = CGPoint(x: frameW / 2, y: frameH / 2)
        bg.zPosition = layers.background
        self.addChild(bg)
    }
    
    
    func getCrystalSpawnPosition(id:Int) -> CGPoint{
        return CGPoint(x: frameW*0.5, y: frameH*0.9)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
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
            // remove health from crystal
            let ct = secondBody.node as! crystal
            let status = ct.takeDamage(1)
            print("health : "+String(ct.healthPoints)+"     scorePoints : "+String(ct.scorePoints))
            if status == 0 {
                print("status == 0")
                self.objectsToRemove.append(ct)
                print("ADDING TO SCORE ",String(ct.scorePoints))
                print("ADD particles at : x ",ct.position.x,"  y: ",ct.position.y)
                explosion(CGPointMake(ct.position.x,ct.position.y), col: ct.vo!.colorValue)
            }
        }
    }
    
    func explosion(pos: CGPoint, col:SKColor) {
        print("MAKE EXPLOSION")
        let emitterNode = SKEmitterNode(fileNamed: "Explosion.sks")
        
        emitterNode!.particleColorSequence = nil;
        emitterNode!.particleColorBlendFactor = 1.0;
        emitterNode!.particleColor = col
        
        let effectNode = SKEffectNode()
        effectNode.zPosition = 20
        emitterNode!.particlePosition = pos
        effectNode.addChild(emitterNode!)
        self.addChild(effectNode)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: {
            print("removing explosion")
            emitterNode!.removeFromParent()
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        let tY = (touchLocation.y<bulletSwipeYMin) ? bulletSwipeYMin : touchLocation.y
        location = CGPoint(x: touchLocation.x, y:tY)
        let angle = atan2(20 - location.y, self.size.width*0.5 - location.x)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        gun.runAction(rotateAction)
        isFingerDown = true
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        let tY = (touchLocation.y<bulletSwipeYMin) ? bulletSwipeYMin : touchLocation.y
        location = CGPoint(x: touchLocation.x, y:tY)
        let angle = atan2(20 - location.y, self.size.width*0.5 - location.x)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        gun.runAction(rotateAction)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){ isFingerDown = false }
    
    func cleaning() {
        objectsLayer.removeChildrenInArray(objectsToRemove)
        gemLayer.removeChildrenInArray(objectsToRemove)
    }
    
    override func update(currentTime: CFTimeInterval) {
        cleaning()
        if isFingerDown { shootBullet() }
        
        if gameon{
            for child in gemLayer.children {
                let pos = child.position as CGPoint
                let yPos = pos.y-CGFloat(gameSpeed)
                child.position = CGPoint(x:pos.x, y:yPos)
            }
            moveCount = moveCount+Int(gameSpeed)
            if moveCount >= rowHeight{
                spawnRow()
                moveCount = 0
            }
        }
        
    }
    
    // Settup the level data here.
    
    func setupLevels(){
        // if already in memory, dont setup again
        if levels.count == 0 {
            
            // Level 0
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 1
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 2
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 3
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 4
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 5
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 6
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 7
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
            
            // Level 8
            levels.append(Level(id:0,data:[[0,0,2,7,7,2,0,0],[1,0,0,2,2,0,0,1],[0,1,0,0,0,0,1,0],[3,0,1,0,0,1,0,3],[0,3,0,4,4,0,3,0],[0,0,5,0,0,5,0,0],[0,6,0,0,0,0,6,0],[7,0,0,2,2,0,0,7],[0,0,2,3,3,2,0,0],[0,2,0,4,4,0,2,0],[2,0,0,5,5,0,0,2],[1,2,0,4,4,0,2,1],[0,1,2,3,3,2,1,0],[0,0,1,2,2,1,0,0],[5,5,0,0,0,0,5,5],[0,0,5,5,5,5,0,0],[5,5,0,0,0,0,5,5],[0,1,0,1,0,1,0,1],[1,0,1,0,1,0,1,0],[0,1,0,1,0,1,0,1],[4,0,4,0,4,0,4,0],[0,2,0,2,0,2,0,2],[5,0,5,0,5,0,5,0],[0,0,0,2,2,0,0,0],[0,0,2,0,0,2,0,0],[0,2,0,0,0,0,2,0],[2,0,0,3,3,0,0,2],[0,0,3,1,1,3,0,0],[0,0,1,1,1,1,0,0],[1,1,0,0,0,0,1,1],[1,0,0,4,1,0,0,1],[4,0,4,0,0,1,0,1],[0,4,0,2,2,0,1,0],[0,0,4,0,0,1,0,0],[0,0,0,4,1,0,0,0],[0,0,0,1,4,0,0,0],[0,0,1,0,0,4,0,0],[0,1,0,0,0,0,4,0],[3,2,3,2,3,2,3,2],[0,0,0,0,0,0,0,0],[2,3,2,3,2,3,2,3],[0,0,0,0,0,0,0,0],[3,0,0,1,1,0,0,3],[0,0,1,0,0,1,0,0],[4,0,1,0,0,1,0,4],[0,4,0,1,1,0,4,0],[2,0,4,0,0,4,0,2],[0,2,0,4,4,0,2,0],[0,0,2,0,0,2,0,0],[0,0,0,2,2,0,0,0],[0,0,0,0,0,0,0,0]]))
            
            //-----------------------
        }
        
        
    }
    
    

}
