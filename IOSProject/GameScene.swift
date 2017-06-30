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
    let playerSpeed: CGFloat = 10.0
    var atkButton: SKSpriteNode!
    var defButton: SKSpriteNode!
    var hmrButton: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    var isAtking: Bool = false
    var isDfnding: Bool = false
    var isHamrd: Bool = false
    var isPausd: Bool = false
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
    
    //animations
    let runAnim = SKAction.repeatForever(SKAction.animate(with: [
        SKTexture(imageNamed: "run_0"),
        SKTexture(imageNamed: "run_1"),
        SKTexture(imageNamed: "run_2"),
        SKTexture(imageNamed: "run_3"),
        SKTexture(imageNamed: "run_4"),
        SKTexture(imageNamed: "run_5")
        ], timePerFrame: 0.1))
    let atkAnim = SKAction.animate(with: [
        SKTexture(imageNamed: "attack_0"),
        SKTexture(imageNamed: "attack_1"),
        SKTexture(imageNamed: "attack_2")
        ], timePerFrame: 0.2)
    let defAnim = SKAction.animate(with: [
        SKTexture(imageNamed: "idle_0"),
        SKTexture(imageNamed: "idle_1"),
        SKTexture(imageNamed: "idle_2")
        ], timePerFrame: 0.2)
    let hmrAnim = SKAction.animate(with: [
        SKTexture(imageNamed: "jump_0"),
        SKTexture(imageNamed: "jump_1"),
        SKTexture(imageNamed: "jump_2")
        ], timePerFrame: 0.4)
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
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
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            background.name = "background"
            addChild(background)
            background.zPosition = -1
        }
        
        addChild(player)
        cameraNode.addChild(atkButton)
        cameraNode.addChild(defButton)
        cameraNode.addChild(hmrButton)
        cameraNode.addChild(pauseButton)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        player.run(runAnim)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(attack), name: Notification.Name(AttackNode.atkBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(defend), name: Notification.Name(DefenseNode.defBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(hammerTime), name: Notification.Name(HammerNode.hmrBtnTouched), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(paused), name: Notification.Name(PauseNode.pauseBtnTouched), object: nil)
        
        
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
        
    }
    
    func attack() {
        if !isAtking {
            print("attack")
            if player.hasActions() {
                player.removeAllActions()
            }
            isAtking = true
            
            let seq = SKAction.sequence([atkAnim, SKAction.run {
                    self.isAtking = false
                }, runAnim])
            
            player.run(seq)
        }
    }
    
    func defend() {
        if !isDfnding {
            print("defend")
            if player.hasActions() {
                player.removeAllActions()
            }
            isDfnding = true
            
            let seq = SKAction.sequence([defAnim, SKAction.run {
                    self.isDfnding = false
                }, runAnim])
            
            player.run(seq)
        }
    }
    
    func hammerTime() {
        if !isHamrd {
            print("hammertime")
            if player.hasActions() {
                player.removeAllActions()
            }
            isHamrd = true
            
            let seq = SKAction.sequence([hmrAnim, SKAction.run {
                    self.isHamrd = false
                }, runAnim])
            
            player.run(seq)
        }
    }
    
    func paused() {
        print("paused")
    }
    
    func movePlayer() {
        player.position.x += playerSpeed
    }

    func backgroundNode() -> SKSpriteNode {
        //1
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        //2
        let background1 = SKSpriteNode(imageNamed: "bg_1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        //3
        let background2 = SKSpriteNode(imageNamed: "bg_2")
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
}
