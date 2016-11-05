//
//  Projectile.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import UIKit
import SpriteKit

class projectile: SKNode {
    
    override init() {
        super.init()   //  initialize the default values from the SuperClass ( SKNode )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTop(_ withTexture: SKTexture) {   // Function for adding the visible texture
        
        let xSize = withTexture.size().width*bulletscale             // Create The texture for the top ( visible sprite )
        let ySize = withTexture.size().height*bulletscale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: withTexture, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 0.5
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        
        self.name = "projectile"
        self.physicsBody?.categoryBitMask = 0x1 << 0
        let top = SKSpriteNode(texture: withTexture, size: size)
        top.zPosition = layers.projectiles                        // set zPosition
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite to the SKNode
        self.addChild(top)
    }
    
}

class cannonBall: projectile {
    
    var texture: SKTexture!
    
    override init() {
        super.init()
        
        self.addTop(texturesBullet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
