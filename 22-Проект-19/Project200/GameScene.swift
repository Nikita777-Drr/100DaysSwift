//
//  GameScene.swift
//  Project200
//
//  Created by User on 23.12.2021.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer:Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 24
    
    var labelScore: SKLabelNode!
    
    var score = 0{
        didSet{
            labelScore.text = "Score: \(score)"
        }
    }
    //колличество запусков ракет
    var number = 0
    
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        
        labelScore = SKLabelNode(fontNamed: "Chalkduster")
        labelScore.text = "Score: 0"
        labelScore.position = CGPoint(x: 8, y: 8)
        labelScore.horizontalAlignmentMode = .left
        addChild(labelScore)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireWorks), userInfo: nil, repeats: true)
    }
    
    @objc func launchFireWorks(){
        let movementAmount:CGFloat = 1800
        
        number += 1
        
        switch Int.random(in: 0...3){
        case 0:
            createFireWork(xMoment: 0, x: 512, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 - 200, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 - 100, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 + 100, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            createFireWork(xMoment: 0, x: 512, y: bottomEdge)
            createFireWork(xMoment: -200, x: 512 - 200, y: bottomEdge)
            createFireWork(xMoment: -100, x: 512 - 100, y: bottomEdge)
            createFireWork(xMoment: 100, x: 512 + 100, y: bottomEdge)
            createFireWork(xMoment: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
        if number == 7{
            gameTimer?.invalidate()
        }
    }
    
    func createFireWork(xMoment:CGFloat, x:Int, y:Int){
        //Создайте SKNodeконтейнер, который будет действовать как контейнер для фейерверка, и поместите его в указанное положение.
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //Создайте узел rocket sprite, дайте ему имя "фейерверк", чтобы мы знали, что это важно, отрегулируйте его colorBlendFactorсвойство, чтобы мы могли его раскрасить, а затем добавьте его в узел контейнера.
        let fireWork = SKSpriteNode(imageNamed: "rocket")
        fireWork.colorBlendFactor = 1
        fireWork.name = "firework"
        node.addChild(fireWork)
        
        
        //Дайте узлу спрайта фейерверка один из трех случайных цветов: голубой, зеленый или красный. Я выбрал голубой, потому что чистый синий цвет не особенно заметен на фоне звездного неба.
        switch Int.random(in: 0...2){
        case 0:
            fireWork.color = .cyan
        case 1:
            fireWork.color = .green
        case 2:
            fireWork.color = .red
        default:
            break
        }
        
        //Создайте UIBezierPathизображение, которое будет представлять движение фейерверка.
        //Скажите узлу контейнера следовать по этому пути, поворачиваясь по мере необходимости.
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMoment, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // Создайте частицы позади ракеты, чтобы она выглядела так, как будто зажжен фейерверк.
        //Добавьте фейерверк к нашему fireworksмассиву, а также к сцене.
        if let emmiter = SKEmitterNode(fileNamed: "fuse"){
            emmiter.position = CGPoint(x: 0, y: -22)
            node.addChild(emmiter)
        }
        
        fireworks.append(node)
        addChild(node)
            
    }
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let emmiterAction = SKAction.wait(forDuration: 2)
            let removeEmmiter = SKAction.run {
                emitter.removeFromParent()
            }
            let actionActive = SKAction.sequence([emmiterAction, removeEmmiter])
            emitter.run(actionActive)
        }

        firework.removeFromParent()
    }
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    
   

}
