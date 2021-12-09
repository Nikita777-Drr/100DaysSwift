//
//  WhackSlot.swift
//  Project
//
//  Created by User on 07.12.2021.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var isVisible = false
    var isHit = false
    
    var charNode:SKSpriteNode!
    var sprite:SKSpriteNode!
    func configure(at position: CGPoint){
        self.position = position
        sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
        
    }
    func show(hidesTime:Double){
        if isVisible {return}
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0{
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
            showFire(char: sprite)
            
        }else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
            showFire(char: sprite)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hidesTime * 3.5)) {[weak self] in
            self?.hides()
        }
    }
    func hides(){
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    func hit(){
        isHit = true
        let deley = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([deley, hide, notVisible]))
        showSmog(char: charNode)
        showFire(char: sprite)
    }
    func showSmog(char:SKSpriteNode){
        if let smogPractice = SKEmitterNode(fileNamed: "MyParticle"){
            smogPractice.position = charNode.position
            addChild(smogPractice)
        }
    }
    func showFire(char:SKSpriteNode){
        if let filePractice = SKEmitterNode(fileNamed: "FireParticles"){
            filePractice.position = sprite.position
            addChild(filePractice)
        }
    }
}
