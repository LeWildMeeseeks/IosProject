//
//  GameOverScene.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-07-07.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    let won: Bool
    
    init(size: CGSize, won: Bool){
        self.won = won
        super.init(size : size)
    }
    
    required init	(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        if(won){
            background = SKSpriteNode(imageNamed: "GameOver")
        } else {
            background = SKSpriteNode(imageNamed: "GameOver")
        }
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.scale(to: (scene?.size)!)
        self.addChild(background)
        
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run{
            let myScene = GameScene(size : self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(SKAction.sequence([wait, block]))
    }
    
}
