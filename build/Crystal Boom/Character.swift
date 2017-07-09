//
//  Character.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import UIKit
import SpriteKit

class character: SKNode {
    
    var scorePoints = 0
    var healthPoints = 0
    var size = CGSize(width: 50, height: 50)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func die() {
        
        
    }
    
}
