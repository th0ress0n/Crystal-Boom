//
//  Ammo.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 9/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import UIKit
import SpriteKit

class ammo: SKNode {
    
    override init() {
        super.init()   //  initialize the default values from the SuperClass ( SKNode )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTop(_ withTexture: SKTexture) {
        let sp = SKSpriteNode()
        
        let xSize = withTexture.size().width*bulletscale             // Create The texture for the top ( visible sprite )
        let ySize = withTexture.size().height*bulletscale
        let size = CGSize(width: xSize, height: ySize)
        
        sp.texture = withTexture
        sp.size = size
        sp.zPosition = 1.0; // try
        
        
        // Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: sp.size.width/2)
//        self.physicsBody?.dynamic = true
//        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 0.6
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0.5
        
        self.physicsBody?.categoryBitMask = bitMasks.BulletCategory
//        self.physicsBody?.collisionBitMask = bitMasks.BorderCategory
        self.physicsBody?.contactTestBitMask = bitMasks.BorderCategory
        
        self.name = "bullet"
        self.addChild(sp)
    }

}


class bullet: ammo {
    
    var texture: SKTexture!
    
    override init() {
        super.init()
        
        self.addTop(texturesBulletSmall)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

