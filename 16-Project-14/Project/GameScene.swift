//
//  GameScene.swift
//  Project
//
//  Created by User on 07.12.2021.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var popupTime = 0.85
    
    var numberRounds = 0
    
    var gameScore:SKLabelNode!
    var score = 0{
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        for node in tappedNodes{
            guard let whacSlot = node.parent?.parent as? WhackSlot else {continue}
            if !whacSlot.isVisible {continue}
            if whacSlot.isHit {continue}
            whacSlot.hit()
            
            if node.name == "charFriend"{
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }else if node.name == "charEnemy"{
                whacSlot.charNode.xScale = 0.85
                whacSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    func createEnemy(){
        numberRounds += 1
        
        if numberRounds >= 50 {
            for slot in slots{
                slot.hides()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            run(SKAction.playSoundFileNamed("gameOverr", waitForCompletion: false))
            gameScore = SKLabelNode(fontNamed: "Chalkduster")
            gameScore.text = "Score: \(score)"
            gameScore.position = CGPoint(x: 400, y: 250)
            gameScore.horizontalAlignmentMode = .left
            gameScore.fontSize = 48
            addChild(gameScore)
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hidesTime: popupTime)
        
        if Int.random(in: 0...12) > 4{slots[1].show(hidesTime: popupTime)}
        if Int.random(in: 0...12) > 8{slots[2].show(hidesTime: popupTime)}
        if Int.random(in: 0...12) > 10{slots[3].show(hidesTime: popupTime)}
        if Int.random(in: 0...12) > 11{slots[4].show(hidesTime: popupTime)}
        
        let minDeley = popupTime / 2.0
        let maxDeley = popupTime * 2.0
        let deley = Double.random(in: minDeley...maxDeley)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + deley) {[weak self] in
            self?.createEnemy()
        }
        
    }
}
