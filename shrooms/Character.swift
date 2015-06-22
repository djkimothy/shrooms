//
//  Player.swift
//  shrooms
//
//  Created by djkimothy on 2015-06-09.
//  Copyright (c) 2015 kl. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    
    var lastTimeFired : CFTimeInterval  = 0
    var fireRate : CFTimeInterval       = 0.4
    
    func fireWeapon(timeInterval: CFTimeInterval) {
        
        
        if (timeInterval - lastTimeFired) > fireRate {
            let bullet = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(5, 5))
            bullet.physicsBody                  = SKPhysicsBody(rectangleOfSize: bullet.size)
            bullet.physicsBody?.dynamic         = false
            bullet.physicsBody?.categoryBitMask = kBulletCategory
            bullet.physicsBody?.contactTestBitMask = kMushroomCategory | kEnemyCategory
            
            let shoot = SKAction.moveBy(CGVectorMake(0, self.scene!.frame.height), duration: 2)
            
            bullet.position = self.position
            
            self.scene!.addChild(bullet)
            bullet.runAction(shoot)
            
            lastTimeFired = timeInterval
        }
        
    }
    
    
    
}