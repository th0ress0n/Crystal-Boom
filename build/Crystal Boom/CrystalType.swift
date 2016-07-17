//
//  CrystalType.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 10/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//
import Foundation
import SpriteKit


class CrystalType {

    var typeID:Int
    var textureName:SKTexture
    var healthValue:Int
    var pointsValue:Int
    var sizeValue:CGFloat
    var colorValue:SKColor
    
    init(id:Int, texture:SKTexture, health:Int, points:Int, size:CGFloat, color:SKColor){
        self.typeID = id
        self.textureName = texture
        self.healthValue = health
        self.pointsValue = points
        self.sizeValue = size
        self.colorValue = color
    }
    
}
