//
//  Enemy.swift
//  shrooms
//
//  Created by djkimothy on 2015-06-14.
//  Copyright (c) 2015 kl. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    case goingRight
    case goingLeft
    case goingDown
}

class Enemy: Character {
    
    var head                = false
    var hitRightWall        = false
    var hitLeftWall         = false
    var direction           = Direction.goingRight
    
    convenience init() {
        
        self.init(color: SKColor.greenColor(), size: CGSizeMake(kEnemyWidth, kEnemyHeight))
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(kEnemyWidth, kEnemyHeight))
        physicsBody?.dynamic = false
        physicsBody?.categoryBitMask    = kEnemyCategory
        physicsBody?.contactTestBitMask = kBulletCategory | kPlayerCategory | kMushroomCategory
    }
    
    final func goDown() {
        
        let moveDown = SKAction.moveByX(0, y: -20, duration: 0.6)
        
        self.direction = .goingDown
        self.runAction(moveDown)
        
    }
    
    final func move() {
        
        if self.hitRightWall {
            
            let moveLeft = SKAction.moveToX(10, duration: 6)
            self.runAction(moveLeft)
            self.hitRightWall   = false
            self.direction      = .goingLeft
            
        } else if self.hitLeftWall {
            
            let moveRight = SKAction.moveToX(self.scene!.frame.width - 10, duration: 6)
            self.runAction(moveRight)
            self.hitLeftWall    = false
            self.direction      = .goingRight
            
        }
        
    }
    
    func contact() {
        
    }
    
}