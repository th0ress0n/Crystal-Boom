//
//  Crystal.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import UIKit
import SpriteKit

class crystal: character {
    
    var health = 10  // define the values required by the protocols used ( pTargetable here )
    
    override init() {
        super.init()   //  initialize the default values from the SuperClass ( character )
    }
    
    func setup(def:CrystalType){
        scorePoints = def.pointsValue
        healthPoints = def.healthValue
        
        let texture = def.textureName
        let xSize = def.sizeValue //texture.size().width*scale
        let ySize = def.sizeValue //texture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 1.0
        self.name = "crystal"
        
        self.physicsBody?.categoryBitMask = bitMasks.CrystalCategory
        self.physicsBody?.collisionBitMask = bitMasks.BulletCategory
        self.physicsBody?.contactTestBitMask = bitMasks.BulletCategory
        
        let top = SKSpriteNode(texture: texture, size: size)
        top.zPosition = layers.characters
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite
        self.addChild(top)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func takeDamage(damage: Int) -> Int {
        healthPoints -= damage
        print("You lost \(damage) hit points")
        if healthPoints <= 0 {
            die()
            print("You are dead now")
        }
        return healthPoints
    }
    
    
    
}