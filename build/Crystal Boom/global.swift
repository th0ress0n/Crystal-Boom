//
//  global.swift
//  Crystal Boom
//
//  Created by Per Thoresson on 7/07/2016.
//  Copyright © 2016 SAMBAVIKING. All rights reserved.
//

import Foundation
import SpriteKit

let texturesCannon = SKTexture(imageNamed: "CannonLG.png")
let texturesBullet = SKTexture(imageNamed: "ball.png")
let texturesBulletSmall = SKTexture(imageNamed: "ball_sm.png")
let textureCrystal = SKTexture(imageNamed: "Gem.png")

let texturesBg = SKTexture(imageNamed: "bg.jpg")

// Crystal Textures
let crystalOneTexture = SKTexture(imageNamed: "cr_round_aqua.png")
let crystalTwoTexture = SKTexture(imageNamed: "cr_diamond_purple.png")
let crystalThreeTexture = SKTexture(imageNamed: "cr_round_pink.png")
let crystalFourTexture = SKTexture(imageNamed: "cr_diamond_yellow.png")
let crystalFiveTexture = SKTexture(imageNamed: "cr_square_red.png")
let crystalSixTexture = SKTexture(imageNamed: "cr_diamond_purple.png")
let crystalSevenTexture = SKTexture(imageNamed: "cr_triangle_aqua.png")
let crystalEightTexture = SKTexture(imageNamed: "cr_triangle_red.png")

// Size params
let scale: CGFloat = 0.3
let cannonscale: CGFloat = 0.4
let bulletscale: CGFloat = 0.25

//------------------------------
var frameW = gameScene.frame.size.width
var frameH = gameScene.frame.size.height
//------------------------------

let bulletSwipeYMin:CGFloat = 180.0

var gameScene: SKScene!

let cannonPosition = CGPoint(x: frameW*0.5, y: 20)

var gameSpeed:CGFloat = 2.0

//-------------------------------
var nodesToRemove = [SKNode]()
var objectsLayer: SKNode!
var gemLayer: SKNode!
var effectLayer: SKNode!
//-------------------------------

var crystalTypes = [CrystalType]()

// Level stuff ------------------
var levelSelected:Int = 0
var levels = [Level]()
var currentLevel:Level!
//-------------------------------


struct layers {
    
    static let background: CGFloat = 0
    static let characters: CGFloat = 2
    static let projectiles: CGFloat = 3
    
}

struct bitMasks {
    
    static let BulletCategory   : UInt32 = 0x1 << 0
    static let CrystalCategory : UInt32 = 0x1 << 1
    static let ModCategory  : UInt32 = 0x1 << 2
    static let BorderCategory : UInt32 = 0x1 << 3
    static let NoContactCategory : UInt32 = 0x1 << 4
}






