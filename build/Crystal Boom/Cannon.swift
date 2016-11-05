//
//  Cannon.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import UIKit
import SpriteKit

class cannon: character {
    override init() {
        super.init()
        
        let texture = texturesCannon
        let xSize = texture.size().width*cannonscale
        let ySize = texture.size().height*cannonscale
        let size = CGSize(width: xSize, height: ySize)
        
        self.name = "cannon"
        
        
        let top = SKSpriteNode(texture: texture, size: size)
        top.zPosition = layers.characters
        top.anchorPoint = CGPoint(x:0.5, y:0.9)
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite
        self.addChild(top)
    }
    
    func setAngle(_ angle:CGFloat) {
        let rotateAction = SKAction.rotate(byAngle: angle, duration: 0.0)
        self.run(rotateAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
