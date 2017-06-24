//
//  AttackButton.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-06-23.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class AttackButton: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        
        
        // PUT ATTACK HERE
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }

}
