//
//  GameScene.swift
//  Project 17
//
//  Created by User on 14.12.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var timeIntervalGame = 1.5
    
    var scoreLabel:SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var possibleEmenies = ["ball2"]
    var isGameOver = false
    var gameTimer:Timer?
    var spriteNum = 0

    
    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: timeIntervalGame, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    
    }
    
    @objc func createEnemy(){
        guard let enemy = possibleEmenies.randomElement() else {return}
 
        spriteNum += 1
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 56...736))
        addChild(sprite)
        
        if spriteNum == 20 && timeIntervalGame > 0.5{
            timeIntervalGame -= 0.1
            spriteNum = 0
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: timeIntervalGame, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        
        if isGameOver{
            sprite.removeFromParent()
        }

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        }else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x < -300{
                node.removeFromParent()
            }
        }
        if !isGameOver{score += 1}
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
        gameOver(param: isGameOver)
    }
    
    func gameOver(param:Bool){
        if param{
            let gameOverr = SKSpriteNode(imageNamed: "gameOver")
            gameOverr.position = CGPoint(x: 512, y: 384)
            gameOverr.zPosition = 1
            addChild(gameOverr)
            run(SKAction.playSoundFileNamed("gameOverr", waitForCompletion: false))
        }
        
    }
}
