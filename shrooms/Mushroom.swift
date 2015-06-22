//
//  Mushroom.swift
//  shrooms
//
//  Created by djkimothy on 2015-06-20.
//  Copyright (c) 2015 kl. All rights reserved.
//

import Foundation
import SpriteKit

class Mushroom: SKSpriteNode {
    
    var hitPoints = 4
    
    convenience init() {
        let size = CGSizeMake(kMushroomWidth, kMushroomHeight)
        let colour = SKColor.blueColor()
        
        self.init(color: colour, size: size)
        
        physicsBody                     = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic            = false
        physicsBody?.categoryBitMask    = kMushroomCategory
        physicsBody?.contactTestBitMask = kBulletCategory | kEnemyCategory 
    }
    
    
    func takeDamage() {
        self.takeDamage(1)
    }
    
    func takeDamage (modifier: Int) {
        hitPoints -= modifier
    }
    
    func contact(body: SKPhysicsBody) {
        
    }
    
}