//
//  Level.swift
//  Crystal Boom
//
//  Created by per thoresson on 11/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import Foundation
import SpriteKit


class Level {
    
    var id:Int
    var data = [NSArray]()
    
    init(id:Int, data:NSArray){
        self.id = id
        self.data = data as! [NSArray]
    }
    
}
