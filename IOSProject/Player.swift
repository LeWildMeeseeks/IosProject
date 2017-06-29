//
//  Player.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-28.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    let runAnim = SKAction.repeatForever(SKAction.animate(with: [
        SKTexture(imageNamed: "run_0"),
        SKTexture(imageNamed: "run_1"),
        SKTexture(imageNamed: "run_2"),
        SKTexture(imageNamed: "run_3"),
        SKTexture(imageNamed: "run_4"),
        SKTexture(imageNamed: "run_5")
        ], timePerFrame: 0.1))
}
