//
//  GameScene.swift
//  Shooter
//
//  Created by Nuala O' Dea on 27/07/2015.
//  Copyright (c) 2015 oisinnolan. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let enemy :UInt32 = 0x1 << 0
    static let bullet :UInt32 = 0x1 << 1
    static let char :UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var char = SKSpriteNode(imageNamed: "ball")
    
    var viewController : GameViewController!
    
    var hits = 0
    
    var gameStarted = false
    var gameOver = false
    var gameOverText = false
    
    var enemyTimer = NSTimer()
    
    var bgColor = UIColor()
    var redColor = UIColor(hue: 0, saturation: 1, brightness: 0.49, alpha: 1.0)
    var orangeColor = UIColor(hue: 0.0806, saturation: 1, brightness: 0.88, alpha: 1.0)
    var yellowColor = UIColor(hue: 0.15, saturation: 1, brightness: 0.82, alpha: 1.0)
    var greenColor = UIColor(hue: 0.3583, saturation: 1, brightness: 0.7, alpha: 1.0)
    var cyanColor = UIColor(hue: 0.4917, saturation: 1, brightness: 0.77, alpha: 1.0)
    var blueColor = UIColor(hue: 0.6194, saturation: 0.81, brightness: 0.71, alpha: 1.0)
    var purpleColor = UIColor(hue: 0.7694, saturation: 0.81, brightness: 0.72, alpha: 1.0)
    var pinkColor = UIColor(hue: 0.8472, saturation: 0.81, brightness: 0.91, alpha: 1.0)
    
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.viewController.checkLevel()
        getBackgroundColor(self.viewController.level)
        self.backgroundColor = bgColor
        
        char.size = CGSize(width: 225, height: 225)
        char.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        char.zPosition = 1.0
        char.physicsBody = SKPhysicsBody(circleOfRadius: char.size.width / 2)
        char.physicsBody?.categoryBitMask = PhysicsCategory.char
        char.physicsBody?.collisionBitMask = PhysicsCategory.enemy
        char.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        char.physicsBody?.affectedByGravity = false
        char.physicsBody?.dynamic = false
        char.name = "char"
        
        self.addChild(char)
        
    }
    
    var enemySpawnRate = 0.65
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if (gameStarted == false) {
        
            self.viewController.hideStart()
            hits = 0
            enemySpawnRate = 0.65
            enemySpeed = 5.0
            enemyTimer = NSTimer.scheduledTimerWithTimeInterval(enemySpawnRate, target: self, selector: Selector("enemies"), userInfo: nil, repeats: true)
            gameStarted = true
            char.runAction(SKAction.scaleTo(0.33, duration: 0.3))
            self.removeAllChildren()
            self.addChild(char)
            self.viewController.checkLevel()
            getBackgroundColor(self.viewController.level)
            self.backgroundColor = bgColor
            
        } else if (gameOverText) {
            
            doNothing()
            
        }
        
        else {
        
            for touch in (touches as! Set<UITouch>) {
                let location = touch.locationInNode(self)
                
                var bullet = SKSpriteNode(imageNamed: "ball")
            
                bullet.position = char.position
                bullet.size = CGSize(width: 20, height: 20)
                bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
                bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
                bullet.physicsBody?.collisionBitMask = PhysicsCategory.enemy
                bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
                bullet.physicsBody?.affectedByGravity = false
                bullet.name = "bullet"
            
                self.addChild(bullet)
            
                var dx = CGFloat(location.x - char.position.x)
                var dy = CGFloat(location.y - char.position.y)
            
                let magnitude = sqrt(dx * dx + dy * dy)
            
                dx /= magnitude
                dy /= magnitude
            
                let vector = CGVector(dx: 20.0 * dx, dy: 20.0 * dy)
            
                bullet.physicsBody?.applyImpulse(vector)
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA != nil && contact.bodyB != nil) {
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
        
                let firstBody = contact.bodyA.node as! SKSpriteNode
                let secondBody = contact.bodyB.node as! SKSpriteNode
                
                if firstBody.name != nil && secondBody.name != nil {
                
                    if (firstBody.name == "enemy") && (secondBody.name == "bullet") {
                        
                        collisionBullet(firstBody, bullet: secondBody)
                        
                    } else if (firstBody.name == "bullet") && (secondBody.name == "enemy") {
                        
                        collisionBullet(secondBody, bullet: firstBody)
                        
                    } else if (firstBody.name == "char") && (secondBody.name == "enemy") {
                        
                        collisionMain(secondBody)
                        
                    } else if (firstBody.name == "enemy") && (secondBody.name == "char") {
                        
                        collisionMain(firstBody)
                        
                    }
                }
            }
            
        }
        
    }
    
    func collisionMain(enemy: SKSpriteNode) {
        
        if hits < 2 {
            
            char.runAction(SKAction.scaleBy(1.5, duration: 0.4))
            enemy.physicsBody?.affectedByGravity = true
            enemy.removeAllActions()
            enemy.removeFromParent()
            
            char.runAction(SKAction.sequence([SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.2), SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)]))
            
            hits++
            
        } else {
            gameOver = true
            enemyTimer.invalidate()
            enemy.removeFromParent()
            
            self.char.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.5))
            self.char.runAction(SKAction.fadeOutWithDuration(0.6))
            self.viewController.hideScore()
            gameOverText = true
            
            delay(0.6) {
                self.removeAllChildren()
                self.viewController.showGameOver()
                self.char.runAction(SKAction.fadeInWithDuration(0.01))
                self.char.runAction(SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.01))
            }
            
            delay(4.0) {
                self.viewController.hideGameOver()
                self.removeAllChildren()
                self.addChild(self.char)
                self.gameStarted = false
                self.gameOverText = false
                self.viewController.showStart()
                self.viewController.resetScore()
                self.hits = 0
                self.viewController.checkLevel()
                self.getBackgroundColor(self.viewController.level)
                self.backgroundColor = self.bgColor
            }
        }
    }
    
    func collisionBullet(enemy:SKSpriteNode, bullet:SKSpriteNode) {
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.affectedByGravity = true
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = true
        
        enemy.physicsBody?.mass = 5.0
        bullet.physicsBody?.mass = 5.0
        
        enemy.removeAllActions()
        bullet.removeAllActions()
        
        enemy.physicsBody?.contactTestBitMask = 0
        enemy.physicsBody?.collisionBitMask = 0
        enemy.name = nil
        
        enemy.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.5))
        
        enemy.runAction(SKAction.fadeOutWithDuration(0.6))
        
        self.viewController.addScore()
        self.viewController.checkLevel()
        self.getBackgroundColor(self.viewController.level)
        self.backgroundColor = self.bgColor
    }
    
    var enemySpeed = 4.3
    
    func enemies() {
        if gameStarted {
            var enemy = SKSpriteNode(imageNamed: "ball")
            enemy.size = CGSize(width: 20, height: 20)
            enemy.color = UIColor.whiteColor()
            enemy.colorBlendFactor = 1.0
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.bullet | PhysicsCategory.char
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.char
            enemy.physicsBody?.dynamic = true
            enemy.name = "enemy"
            enemySpeed -= 0.025
            if(enemySpawnRate == 0.1) {
                enemySpawnRate = 0.1
            }
            if(enemySpawnRate == 0) {
                enemySpawnRate = 0.1
            }
            if (enemySpeed == 0.1) {
                enemySpeed = 0.1
            }
            if (enemySpeed == 0.0) {
                enemySpeed = 0.1
            }
            
            let rand = (arc4random() % 4) + 1
            
            switch(rand) {
            case 1:
                
                enemy.position.x = 0
                var yPos = arc4random_uniform(UInt32(frame.size.height))
                enemy.position.y = CGFloat(yPos)
                
                self.addChild(enemy)
                
                break
                
            case 2:
                
                enemy.position.y = 0
                var xPos = arc4random_uniform(UInt32(frame.size.width))
                enemy.position.x = CGFloat(xPos)
                
                self.addChild(enemy)
                
                break
                
            case 3:
                
                enemy.position.y = frame.size.height
                var xPos = arc4random_uniform(UInt32(frame.size.width))
                enemy.position.x = CGFloat(xPos)
                
                self.addChild(enemy)
                
                break
                
            case 4:
                
                enemy.position.x = frame.size.width
                var yPos = arc4random_uniform(UInt32(frame.size.height))
                enemy.position.y = CGFloat(yPos)
                
                self.addChild(enemy)
                
                break
                
            default:()
            }
            
            enemy.runAction(SKAction.moveTo(char.position, duration: NSTimeInterval(enemySpeed)))
        }
    }
    
    func getBackgroundColor(level : Int) {
        switch(level) {
        case 1:
            bgColor = UIColor.blackColor()
            break
        case 2:
            bgColor = redColor
            self.viewController.startLabel.textColor = redColor
            break
        case 3:
            bgColor = orangeColor
            self.viewController.startLabel.textColor = orangeColor
            break
        case 4:
            bgColor = yellowColor
            self.viewController.startLabel.textColor = yellowColor
            break
        case 5:
            bgColor = greenColor
            self.viewController.startLabel.textColor = greenColor
            break
        case 6:
            bgColor = cyanColor
            self.viewController.startLabel.textColor = cyanColor
            break
        case 7:
            bgColor = blueColor
            self.viewController.startLabel.textColor = blueColor
            break
        case 8:
            bgColor = purpleColor
            self.viewController.startLabel.textColor = purpleColor
            break
        case 9:
            bgColor = pinkColor
            self.viewController.startLabel.textColor = pinkColor
            break
        default:
            doNothing()
            break
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    func delay(delayInSeconds:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func doNothing() {
    
    }
}
