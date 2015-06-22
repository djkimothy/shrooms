//
//  GameScene.swift
//  shrooms
//
//  Created by djkimothy on 2015-06-07.
//  Copyright (c) 2015 kl. All rights reserved.
//

import SpriteKit

//Physics bitmasks
let kBulletCategory: UInt32      = 0x1 << 0
let kMushroomCategory: UInt32    = 0x1 << 1
let kEnemyCategory: UInt32       = 0x1 << 2
let kPlayerCategory: UInt32      = 0x1 << 3

//Object dimensions
let kEnemyWidth: CGFloat    = 20
let kEnemyHeight: CGFloat   = 20

let kPlayerWidth: CGFloat   = 10
let kPlayerHeight: CGFloat  = 20

let kMushroomWidth: CGFloat     = 15
let kMushroomHeight: CGFloat    = 15

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isShooting      = false
    var started         = false

    var firingTimer     = NSTimer()
    var catepillar      = [Enemy]()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.contactDelegate = self
        
        setupWorld()
        createPlayer()
        createEnemy()
        setupPhysics()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        isShooting = true
    }
    

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            activateCharacter(location)
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        isShooting = false
    }
        
   
    override func update(currentTime: CFTimeInterval) {
        
        if isShooting {
            let player = self.childNodeWithName("player") as! Character
            player.fireWeapon(currentTime)
        }
        
        updateCaterpillar(currentTime)
    }
    
    override func didEvaluateActions() {
        
        for enemyBody in catepillar {
            if enemyBody.position.x == self.frame.width - 10 && enemyBody.direction == .goingRight {
                enemyBody.hitRightWall = true
            }
            
            if enemyBody.position.x == 10 && enemyBody.direction == .goingLeft {
                enemyBody.hitLeftWall = true
            }
            
        }
    }
    
    //Evaluate object contacts
    private func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
    }
    
    private func createPlayer() {
        
        let player = Character(color: SKColor.redColor(), size: CGSizeMake(kPlayerWidth, kPlayerHeight))
        
        player.position = CGPointMake(self.frame.size.width / 2, 35)
        player.name = "player"
        
        self.addChild(player)
        
    }
    
    private func createEnemy() {
        
        for index in 1...12 {
            let enemy = Enemy()
            enemy.name = "enemy"
            enemy.position = CGPointMake(10, self.size.height - 50)
            
            catepillar.append(enemy)
            self.addChild(enemy)
        }
        
        catepillar[0].head = true
        
        started = true
        
    }
    
    private func setupPhysics() {
        
        
        
    }
    
    private func setupWorld() {
        
        var buffer = self.size.height - 90
        
        for _ in 1...11 {
            setupRow(buffer)
            buffer -= 20
        }
        
    }
    
    private func setupRow(row: CGFloat) {
        
        let end                 = Int(self.size.width - 10)
        let start               = 10
        var lastMushroom        = Mushroom()
        
        lastMushroom.position   = CGPointMake(0, 0)
        
        for index in start...end {
            
            if arc4random_uniform(300) < 2 {
                var mushroom = Mushroom()
                mushroom.position = CGPointMake(CGFloat(index), row)
                if !mushroom.intersectsNode(lastMushroom) {
                    mushroom.name = "shroom"
                    self.addChild(mushroom)
                    lastMushroom = mushroom
                }
            }
        }
        
    }
    
    private func updateCaterpillar(currentTimeInterval: CFTimeInterval) {
        
        var move = SKAction()
        
        //Enemy's start
        if started {
            var buffer = 0.6
            
            for enemyBody in catepillar {
                move = SKAction.moveToX(self.frame.width - 10, duration: 6)
                let idle = SKAction.waitForDuration(buffer)
                enemyBody.runAction(SKAction.sequence([idle, move]))
                buffer += 0.45
            }
            started = false
        }
        
        
        //Enemy state; this checks if the enemy has hit a wall and in what direction... then moves it in reacts in direction change (only wall)
        for enemyBody in catepillar {
            
            if enemyBody.hitRightWall && enemyBody.direction == .goingRight {
                enemyBody.goDown()
            } else if enemyBody.hitLeftWall && enemyBody.direction == .goingLeft {
                enemyBody.goDown()
            }
            
            if !enemyBody.hasActions() {
                enemyBody.move()
            }
        }
    }
    
    
    private func activateCharacter(location: CGPoint) {
        
        if let player = self.childNodeWithName("player") {
            
            if location.x < 5 {
                player.position.x = 5
                
            } else if location.x > self.frame.size.width - 5 {
                player.position.x = self.frame.size.width - 5
            } else {
                player.position.x = location.x
            }
            
        }
        
     
        
    }
}
