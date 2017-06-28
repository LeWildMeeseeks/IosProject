//
//  GameScene.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-20.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "attack_0")
    let playerSpeed: CGFloat = 10.0
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
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        player.position = CGPoint(x: 400, y: 700)
        player.zPosition = 100
        player.setScale(20)
        
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
        print("\(player.size)")
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        cameraNode.position = CGPoint(x: player.position.x + (scene?.size.width)! * 0.3,
                                    y: player.position.y + (scene?.size.height)! * 0.15)
        
        moveCamera()
        movePlayer()
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
