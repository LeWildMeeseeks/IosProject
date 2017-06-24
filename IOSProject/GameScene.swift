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
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene {
    
    var player = Player()
    
    override func didMove(to view: SKView){
        print("hey")
        
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode{
                eventListenerNode.didMoveToScene()
            }
        })
        
        addChild(player)
    
    }
    
}
