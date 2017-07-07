//
//  GameScene.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-20.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func interact()
    func didMoveToScene()
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "attack_0")
    let player2 = SKSpriteNode(imageNamed: "playerbox")
    
    let randomSlimes: [String] = ["red","yellow","green","blue"]
    
    
    let playerSpeed: CGFloat = 10.0
    let slimeSpeed: CGFloat = 6.0
    var lives: Int = 3 {
        didSet {
            heartsChanged()
        }
    }

    
    var hitBox: CGRect!
    var atkBox: CGRect!
    var defBox: CGRect!
    var kickBox: CGRect!
    
    var atkButton: SKSpriteNode!
    var defButton: SKSpriteNode!
    var hmrButton: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    
    var isAtking: Bool = false
    var isGrding: Bool = false
    var isKcking: Bool = false
    
    let cameraMovePointsPerSec: CGFloat = 200.0
    var lastUpdateTime: TimeInterval = 0
    var playableRect: CGRect!
    var dt: TimeInterval = 0
    
    let cameraNode = SKCameraNode()
    var cameraRect: CGRect {
        let x = cameraNode.position.x - size.width * 0.5 + (size.width - playableRect.width) * 0.5
        let y = cameraNode.position.y - size.height * 0.5 + (size.height - playableRect.height) * 0.5
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
    
    let runAnim = SKAction.repeatForever(SKAction.animate(with: [
        SKTexture(imageNamed: "run_0"),
        SKTexture(imageNamed: "run_1"),
        SKTexture(imageNamed: "run_2"),
        SKTexture(imageNamed: "run_3"),
        SKTexture(imageNamed: "run_4"),
        SKTexture(imageNamed: "run_5")
        ], timePerFrame: 0.1))
    
   
    
    override func didMove(to view: SKView) {
        player2.setScale(3.5)
        hitBox = CGRect(x: 0, y: 0, width: player2.size.width, height: player2.size.height)
        atkBox = CGRect(x: 0, y: 0, width: player2.size.width, height: player2.size.height)
        defBox = CGRect(x: 0, y: 0, width: player2.size.width, height: player2.size.height)
        kickBox = CGRect(x: 0, y: 0, width: player2.size.width, height: player2.size.height)
        
        backgroundColor = SKColor.black

        // MARK : HIT BOX TEST
        let hitBoxImage = SKShapeNode(rect: hitBox)
        hitBoxImage.name = "box"
//        hitBoxImage.position = CGPoint(x: 1000, y: 700)
        hitBoxImage.fillColor = SKColor.red
        hitBoxImage.zPosition = 3
        //~~~~~~~~~~~~~~~~~~~~~
        
        player.position = CGPoint(x: 400, y: 700)
        player.setScale(3.5)

    
        atkButton = childNode(withName: "atkBtn") as? SKSpriteNode
        atkButton.removeFromParent()
        atkButton.position = CGPoint(x: -850, y: -400)
        atkButton.setScale(1.5)
        
        defButton = childNode(withName: "defBtn") as? SKSpriteNode
        defButton.removeFromParent()
        defButton.position = CGPoint(x: 850, y: -400)
        defButton.setScale(1.5)
        
        hmrButton = childNode(withName: "hmrBtn") as? SKSpriteNode
        hmrButton.removeFromParent()
        hmrButton.position = CGPoint(x: -550, y: -400)
        hmrButton.setScale(1.5)
        
        pauseButton = childNode(withName: "pauseBtn") as? SKSpriteNode
        pauseButton.removeFromParent()
        pauseButton.position = CGPoint(x: 850, y: 400)
        pauseButton.setScale(1.5)
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) * 0.5
        
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)

        for i in 0...1 {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: (scene?.size.height)! * 0.125)
            background.scale(to: (scene?.size)!)
            background.name = "background"
            background.zPosition = -1
            addChild(background)
        }
        
        addChild(player)
        addChild(hitBoxImage)
        
        cameraNode.addChild(atkButton)
        cameraNode.addChild(defButton)
        cameraNode.addChild(hmrButton)
        cameraNode.addChild(pauseButton)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(attack), name: Notification.Name(AttackNode.atkBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(defend), name: Notification.Name(DefenseNode.defBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(hammerTime), name: Notification.Name(HammerNode.hmrBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(pause), name: Notification.Name(PauseNode.pauseBtnTouched), object: nil)
        
        for i in 1...3 {
            let node = childNode(withName: "\(i)") as? SKSpriteNode
            node?.removeFromParent()
            node?.position = CGPoint(x: -((scene?.size.width)! * 0.3) - (node?.size.width)! * CGFloat(i - 1) , y: 450)
            cameraNode.addChild(node!)
        }
        
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnSlime()}, SKAction.wait(forDuration: 4.0)])))
    }
    
    override func didEvaluateActions() {
        checkCollisions()
        hearts()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        cameraNode.position = CGPoint(x: player.position.x + (scene?.size.width)! * 0.3,
                                    y: player.position.y + (scene?.size.height)! * 0.05)
        
        moveCamera()
        
        movePlayer()
        if !player.hasActions(){
            player.run(runAnim)
        }
        
    }
    
    func attack() {
        if !isAtking && !isGrding && !isKcking{
            print("attack")
            
            player.removeAllActions()
            
            let atkAnim = SKAction.animate(with: [
                SKTexture(imageNamed: "attack_0"),
                SKTexture(imageNamed: "attack_1"),
                SKTexture(imageNamed: "attack_2")
                ], timePerFrame: 0.2)
            
            isAtking = true
            
//            let node = childNode(withName: "box")
//            node?.zPosition = 0
//            node?.position = CGPoint(x: (player.position.x + player.size.width * 0.125), y: player.position.y - player.size.height * 0.35)
            
            atkBox.origin = CGPoint(x: (player.position.x + player.size.width * 0.125), y: player.position.y - player.size.height * 0.35)
            
            player.run(SKAction.sequence([atkAnim,SKAction.run{self.isAtking = false}]))
        }
    }
    
    func defend() {
        if !isGrding && !isAtking && !isKcking{
            print("defend")
            
            isGrding = true
            
            let circle = SKShapeNode(circleOfRadius: 50.0)
            circle.zPosition = 2
            circle.position = CGPoint(x: 0 - player.size.width / 40, y: 0 - player.size.height / 128)
            circle.fillColor = .white
            circle.alpha = 0.4
            circle.strokeColor = .yellow
            circle.glowWidth = 5
            circle.name = "circle"
            player.addChild(circle)
            
            let action = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
            
            let action2 = SKAction.fadeAlpha(to: 0.5, duration: 0.3)
            
            let blinking = SKAction.sequence([action, action2, action, SKAction.run {
                circle.removeFromParent()
                }])
            
            defBox.origin = CGPoint(x: (player.position.x + player.size.width * 0.125), y: player.position.y - player.size.height * 0.35)
            
            //        circle.run(SKAction.repeatForever(blinking))
            circle.run(SKAction.sequence([blinking,SKAction.run{self.isGrding = false}]))
        }
    }
    
    func hammerTime() {
        if !isKcking && !isAtking && !isGrding{
            print("hammered")
            
            isKcking = true
            
            let atkAnim = SKAction.animate(with: [
                SKTexture(imageNamed: "attack_0"),
                SKTexture(imageNamed: "attack_1"),
                SKTexture(imageNamed: "attack_2")
                ], timePerFrame: 0.2)
            
            kickBox.origin = CGPoint(x: (player.position.x + player.size.width * 0.125), y: player.position.y - player.size.height * 0.35)
            
            
            player.run(SKAction.sequence([atkAnim,SKAction.run{self.isKcking = false}]))
        }
        
    }
    
    func pause() {
        print("paused")
        spawnKnight()
    }

    
    func movePlayer() {
        player.position.x += playerSpeed
        
        hitBox.origin = CGPoint(x: player.position.x - player.size.width * 0.25, y: player.position.y - player.size.height * 0.35)
       
    }
    

    func backgroundNode() -> SKSpriteNode {
        //1
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        //2
        let background1 = SKSpriteNode(imageNamed: "castle")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        //3
        let background2 = SKSpriteNode(imageNamed: "castle")
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)
        backgroundNode.addChild(background2)
        
        //4
        backgroundNode.size = CGSize(width: background1.size.width + background2.size.width,
                                     height: background1.size.height)
        return backgroundNode
    }
    
    func moveCamera() {
        let backgroundVelocity = CGPoint(x: cameraMovePointsPerSec, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width < self.cameraRect.origin.x {
                background.position = CGPoint(
                    x: background.position.x + background.size.width * 2,
                    y: background.position.y)
            }
        }
    }
    
    
    // MARK: TEST COLLISION n' SPAWNING
    func spawnSlime(){
        let slime = SKSpriteNode(imageNamed: "greenslime1")
        slime.name = "enemy"
        slime.position = CGPoint(x: cameraRect.maxX + slime.size.width, y: player.position.y - player.size.width * 0.25)
        
        slime.setScale(8)
        
        let color = "\(randomSlimes[Int.random(min:0, max: 3)])"
        
        let slimeAnim = SKAction.repeatForever(SKAction.animate(with: [
            SKTexture(imageNamed: "\(color)slime1"),
            SKTexture(imageNamed: "\(color)slime2")],
            timePerFrame: 0.3))

        addChild(slime)
        slime.run(slimeAnim)
        
    }
    
    func spawnKnight(){
        let knight = SKSpriteNode(imageNamed: "knight1")
        knight.name = "knight"
        knight.position = CGPoint(x: cameraRect.maxX + knight.size.width, y: 650)
        
        knight.setScale(11)
        knight.xScale = knight.xScale * -1
        
        let knightAnim = SKAction.repeatForever(SKAction.animate(with: [
            SKTexture(imageNamed: "knight1"),
            SKTexture(imageNamed: "knight2")],
            timePerFrame: 0.2))
        
        addChild(knight)
        knight.run(knightAnim)
        print("\(knight.position.y)")
        
    }
    
    func hearts() {
        //        guard let scene = scene else {
        //            return
        //        }
        
        for i in 1...3 {
            let heart = childNode(withName: "\(i)") as? SKSpriteNode
            heart?.position = CGPoint(
                x: 0,
                y: 0)
            heart?.zPosition = 100
        }
    }
    
    func heartsChanged() {
        guard let scene = scene else {
            return
        }
        
        print("heart")
        
        for i in 1...3
        {
            let node = scene.camera?.childNode(withName: "\(i)") as? SKSpriteNode
            
            if lives == 0 {
                node?.alpha = 0
            }
            else if lives == 3 {
                node?.alpha = 1
            }
            else if lives == 2 && i == 1 {
                node?.alpha = 0
            }
            else if lives == 1 && i == 1 || lives == 1 && i == 2 {
                node?.alpha = 0
            }
            else {
                node?.alpha = 1
            }
        }
    }
    
    func playerDamage(enemy: SKSpriteNode){
        lives -= 1
        print("\(lives)")
        enemy.removeFromParent()
    }
    
    func playerAtk(enemy: SKSpriteNode){
        print("Kill")
        enemy.removeFromParent()
    }
    
    func checkCollisions(){
        
        var takeDamage: [SKSpriteNode] = []
        var eraseObject: [SKSpriteNode] = []
        
        enumerateChildNodes(withName: "enemy") { node, _ in
            let slime = node as! SKSpriteNode
            if self.isAtking {
                if slime.frame.intersects(self.atkBox){
                    eraseObject.append(slime)
                }
               
            } else {
                if slime.frame.intersects(self.hitBox){
                    takeDamage.append(slime)
                }
            }
            
        }
        
        enumerateChildNodes(withName: "arrow") { node, _ in
            let arrow = node as! SKSpriteNode
            if self.isGrding {
                    if arrow.frame.intersects(self.defBox){
                        eraseObject.append(arrow)
                    }
            } else {
                if arrow.frame.intersects(self.hitBox){
                    takeDamage.append(arrow)
                }
            }
        }
        
        enumerateChildNodes(withName: "knight") { node, _ in
            let knight = node as! SKSpriteNode
            if self.isKcking {
                if knight.frame.intersects(self.kickBox){
                    eraseObject.append(knight)
                }
            } else {
                if knight.frame.intersects(self.hitBox){
                    takeDamage.append(knight)
                }
            }
        }
        
        for slime in takeDamage{
            playerDamage(enemy: slime)
        }
        
        for slime in eraseObject{
            playerAtk(enemy: slime)
        }
        
        
    }
    
    
}
