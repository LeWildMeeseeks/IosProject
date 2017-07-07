//
//  MainMenuScene.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-07-07.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    
    override init(size: CGSize){
        
        super.init(size:size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "mainmenu")
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        background.scale(to: (scene?.size)!)
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        sceneTap()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        sceneTap()
    }
    
    func sceneTap(){
        
        let block = SKAction.run(){
            let scene = GameScene(size: self.size)
            scene.scaleMode = self.scaleMode
            let reveal = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
        self.run(block)
    }
    
}
