//
//  AttackNode.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-28.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class AttackNode: SKSpriteNode, EventListenerNode {
    
    static let atkBtnTouched = "attack"
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
       NotificationCenter.default.post(Notification(name: NSNotification.Name(AttackNode.atkBtnTouched), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }

}
