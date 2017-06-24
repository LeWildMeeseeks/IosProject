//
//  RunnerNode.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-06-23.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, EventListenerNode {

    
    func didMoveToScene() {
        print("Player Here")
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(){
        let texture = SKTexture(pixelImageNamed: "player_01")
        super.init(texture: texture, color: .white, size: CGSize(width: 100, height: 100))
        name = "Player"
        zPosition = 50
        
    }
}
