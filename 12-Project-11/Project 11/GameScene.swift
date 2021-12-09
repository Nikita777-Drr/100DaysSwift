//
//  GameScene.swift
//  Project 11
//
//  Created by User on 25.11.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel:SKLabelNode!
    var editLabel:SKLabelNode!
    var numberLabel:SKLabelNode!
    
    var editMode:Bool = false{
        didSet{
            if editMode{
                editLabel.text = "Done"
            }else{
                editLabel.text = "Edit"
            }
        }
    }
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var numberBall = 5{
        didSet{
            numberLabel.text = "Ball: \(numberBall)"
        }
    }
    
    var arrayBall = ["ballRed","ballBlue","ballCyan","ballGreen","ballGrey","ballPurple","ballYellow"]

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed:"background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        numberLabel = SKLabelNode(fontNamed: "Chalkduster")
        numberLabel.text = "Ball: 5"
        numberLabel.horizontalAlignmentMode = .right
        numberLabel.position = CGPoint(x: 980, y: 660)
        addChild(numberLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        if object.contains(editLabel){
            editMode.toggle()
        }else {
            if editMode{
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            }else{
                if numberBall >= 1{
                    let ball = SKSpriteNode(imageNamed: arrayBall.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = CGPoint(x: location.x, y: 700)
                    addChild(ball)
                    ball.name = "ball"
                }
            }
        }
        
        
    }
    func makeBouncer(at position:CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    func makeSlot(at position: CGPoint, isGood:Bool){
       
        var slotBase:SKSpriteNode
        var slowGlow:SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slowGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slowGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        slowGlow.position = position
        
        addChild(slowGlow)
        addChild(slotBase)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slowGlow.run(spinForever)
    }
    func collisionBetween(ball:SKNode,object:SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
            numberBall += 1
        }else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
            numberBall -= 1
        }
    }
    func destroy(ball:SKNode){
        if let filePartice =  SKEmitterNode(fileNamed: "FireParticles"){
            filePartice.position = ball.position
            addChild(filePartice)
        }
        ball.removeFromParent()
    }
    func didBegin(_ contact:SKPhysicsContact){
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        
        if nodeA.name == "ball"{
            collisionBetween(ball: nodeA, object: nodeB)
        }else if nodeB.name == "ball"{
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
  
}
