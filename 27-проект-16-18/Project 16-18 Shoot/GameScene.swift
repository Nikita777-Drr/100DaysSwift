//
//  GameScene.swift
//  Project 16-18 Shoot
//
//  Created by User on 18.12.2021.
//

import SpriteKit

class GameScene: SKScene {
    var enemy1:SKSpriteNode!
    var enemy2:SKSpriteNode!
    var enemy3:SKSpriteNode!
    
    var level = 0
    
    var gameover:SKSpriteNode!
    var button:SKSpriteNode!
    
    var backGround:SKSpriteNode!
    
    var gameScore:SKLabelNode!
    var score = 0{
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    var gameTimer:Timer?
    var isGameOver = false
    var allEnemy = ["prizrak2","prizrak3"]
    var allEnemy2 = ["monster1","monster2"]
    var allEnemy3 = ["mostr1","mostr2"]
    var allEnemy4 = ["prizrak3","monster2", "mostr2"]
    
    var timeSec = 7
    var gameTimerSec = 10

    override func didMove(to view: SKView) {
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)

        addEnemy()
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(gameTimerSec), target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
    }
    
    
    @objc func addEnemy(){
        let positionNum = [100, 950]
        level += 1
        
        if level == 1{
            backGround = SKSpriteNode(imageNamed: "фон")
            backGround.position = CGPoint(x: 512, y: 384)
            backGround.size = CGSize(width: 1280, height: 1024)
            backGround.blendMode = .replace
            backGround.zPosition = -1
            addChild(backGround)
            
            enemy1 = SKSpriteNode(imageNamed: allEnemy.randomElement()!)
            enemy1.position = CGPoint(x: positionNum.randomElement()! , y: 100)
            if enemy1.position.x == 100{
                enemy1.run(SKAction.moveBy(x: 1050, y: 0, duration: TimeInterval(timeSec)))
            }else if enemy1.position.x == 950 {
                enemy1.run(SKAction.moveBy(x: -1100, y: 0, duration: TimeInterval(timeSec)))
            }
            addChild(enemy1)
            enemy2 = SKSpriteNode(imageNamed: allEnemy.randomElement()!)
            enemy2.position = CGPoint(x: positionNum.randomElement()! , y: 400)
            if enemy2.position.x == 100{
                enemy2.run(SKAction.moveBy(x: 1050, y: 0, duration: TimeInterval(timeSec)))
            }else if enemy2.position.x == 950 {
                enemy2.run(SKAction.moveBy(x: -1100, y: 0, duration: TimeInterval(timeSec)))
            }
            addChild(enemy2)
            enemy3 = SKSpriteNode(imageNamed: allEnemy.randomElement()!)
            enemy3.position = CGPoint(x: positionNum.randomElement()! , y: 650)
            if enemy3.position.x == 100{
                enemy3.run(SKAction.moveBy(x: 1050, y: 0, duration: TimeInterval(timeSec)))
            }else if enemy3.position.x == 950 {
                enemy3.run(SKAction.moveBy(x: -1100, y: 0, duration: TimeInterval(timeSec)))
            }
            addChild(enemy3)
            run(SKAction.playSoundFileNamed("soundPrizrak", waitForCompletion: true))
        }else if level == 2{
            backGround.removeFromParent()
            backGround = SKSpriteNode(imageNamed: "fon")
            backGround.position = CGPoint(x: 512, y: 384)
            backGround.size = CGSize(width: 1280, height: 1024)
            backGround.blendMode = .replace
            backGround.zPosition = -1
            addChild(backGround)
            
            enemy1 = SKSpriteNode(imageNamed: allEnemy2.randomElement()!)
            enemy1.position = CGPoint(x: positionNum.randomElement()! , y: 100)
            if enemy1.position.x == 100{
                enemy1.run(SKAction.moveBy(x: 1000, y: 100, duration: TimeInterval(timeSec - 1)))
            }else if enemy1.position.x == 950 {
                enemy1.run(SKAction.moveBy(x: -1050, y: 100, duration: TimeInterval(timeSec - 1)))
            }
            addChild(enemy1)
            enemy2 = SKSpriteNode(imageNamed: allEnemy2.randomElement()!)
            enemy2.position = CGPoint(x: positionNum.randomElement()! , y: 400)
            if enemy2.position.x == 100{
                enemy2.run(SKAction.moveBy(x: 1000, y: 50, duration: TimeInterval(timeSec - 1)))
            }else if enemy2.position.x == 950 {
                enemy2.run(SKAction.moveBy(x: -1050, y: 50, duration: TimeInterval(timeSec - 1)))
            }
            addChild(enemy2)
            enemy3 = SKSpriteNode(imageNamed: allEnemy2.randomElement()!)
            enemy3.position = CGPoint(x: positionNum.randomElement()! , y: 650)
            if enemy3.position.x == 100{
                enemy3.run(SKAction.moveBy(x: 1000, y: -100, duration: TimeInterval(timeSec - 1)))
            }else if enemy3.position.x == 950 {
                enemy3.run(SKAction.moveBy(x: -1050, y: -100, duration: TimeInterval(timeSec - 1)))
            }
            addChild(enemy3)
            run(SKAction.playSoundFileNamed("soundPrizrak", waitForCompletion: true))
        }else if level == 3{
            backGround.removeFromParent()
            backGround = SKSpriteNode(imageNamed: "fon1")
            backGround.position = CGPoint(x: 512, y: 384)
            backGround.size = CGSize(width: 1600, height: 1024)
            backGround.blendMode = .replace
            backGround.zPosition = -1
            addChild(backGround)
            
            enemy1 = SKSpriteNode(imageNamed: allEnemy3.randomElement()!)
            enemy1.position = CGPoint(x: positionNum.randomElement()! , y: 100)
            if enemy1.position.x == 100{
                enemy1.run(SKAction.moveBy(x: 1000, y: 200, duration: TimeInterval(timeSec - 2)))
            }else if enemy1.position.x == 950 {
                enemy1.run(SKAction.moveBy(x: -1050, y: 200, duration: TimeInterval(timeSec - 2)))
            }
            addChild(enemy1)
            enemy2 = SKSpriteNode(imageNamed: allEnemy3.randomElement()!)
            enemy2.position = CGPoint(x: positionNum.randomElement()! , y: 400)
            if enemy2.position.x == 100{
                enemy2.run(SKAction.moveBy(x: 1000, y: 100, duration: TimeInterval(timeSec - 2)))
            }else if enemy2.position.x == 950 {
                enemy2.run(SKAction.moveBy(x: -1050, y: 100, duration: TimeInterval(timeSec - 2)))
            }
            addChild(enemy2)
            enemy3 = SKSpriteNode(imageNamed: allEnemy3.randomElement()!)
            enemy3.position = CGPoint(x: positionNum.randomElement()! , y: 650)
            if enemy3.position.x == 100{
                enemy3.run(SKAction.moveBy(x: 1000, y: -200, duration: TimeInterval(timeSec - 2)))
            }else if enemy3.position.x == 950 {
                enemy3.run(SKAction.moveBy(x: -1050, y: -200, duration: TimeInterval(timeSec - 2)))
            }
            addChild(enemy3)
            run(SKAction.playSoundFileNamed("soundPrizrak", waitForCompletion: true))
        }else if level == 4{
            backGround.removeFromParent()
            backGround = SKSpriteNode(imageNamed: "fon2")
            backGround.position = CGPoint(x: 512, y: 384)
            backGround.size = CGSize(width: 1280, height: 1024)
            backGround.blendMode = .replace
            backGround.zPosition = -1
            addChild(backGround)
            
            enemy1 = SKSpriteNode(imageNamed: allEnemy4.randomElement()!)
            enemy1.position = CGPoint(x: positionNum.randomElement()! , y: 100)
            if enemy1.position.x == 100{
                enemy1.run(SKAction.moveBy(x: 1000, y: 300, duration: TimeInterval(timeSec - 3)))
            }else if enemy1.position.x == 950 {
                enemy1.run(SKAction.moveBy(x: -1050, y: 300, duration: TimeInterval(timeSec - 3)))
            }
            addChild(enemy1)
            enemy2 = SKSpriteNode(imageNamed: allEnemy4.randomElement()!)
            enemy2.position = CGPoint(x: positionNum.randomElement()! , y: 400)
            if enemy2.position.x == 100{
                enemy2.run(SKAction.moveBy(x: 1000, y: 150, duration: TimeInterval(timeSec - 3)))
            }else if enemy2.position.x == 950 {
                enemy2.run(SKAction.moveBy(x: -1050, y: 150, duration: TimeInterval(timeSec - 3)))
            }
            addChild(enemy2)
            enemy3 = SKSpriteNode(imageNamed: allEnemy4.randomElement()!)
            enemy3.position = CGPoint(x: positionNum.randomElement()! , y: 650)
            if enemy3.position.x == 100{
                enemy3.run(SKAction.moveBy(x: 1000, y: -300, duration: TimeInterval(timeSec - 3)))
            }else if enemy3.position.x == 950 {
                enemy3.run(SKAction.moveBy(x: -1050, y: -300, duration: TimeInterval(timeSec - 3)))
            }
            addChild(enemy3)
            run(SKAction.playSoundFileNamed("soundPrizrak", waitForCompletion: true))
        }
        if level == 5{
            gameOver()
            gameTimer?.invalidate()
        }
       
        
        if gameTimerSec >= 5{
            gameTimerSec -= 1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNode = nodes(at: location)
        
        for node in tappedNode{
            if node.position == enemy1.position{
                enemy1.removeFromParent()
                score += 4
            }
            if node.position == enemy2.position{
                enemy2.removeFromParent()
                score += 4
            }
            if node.position == enemy3.position{
                enemy3.removeFromParent()
                score += 4
            }
            if node.position == backGround.position {
                score -= 2
            }
            
            if score < -20{
                gameOver()
            }
            
        }
        
    }
    
    func gameOver(){
        gameTimer?.invalidate()
        gameover = SKSpriteNode(imageNamed: "gameOver")
        gameover.position = CGPoint(x: 512, y: 384)
        gameover.zPosition = 1
        gameover.run(SKAction.playSoundFileNamed("gameOverr", waitForCompletion: false))
        addChild(gameover)
    }
}
