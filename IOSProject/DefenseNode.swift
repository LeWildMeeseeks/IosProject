//
//  DefenseButton.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-29.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class DefenseNode: SKSpriteNode, EventListenerNode {
    static let defBtnTouched = "defend"
    
    func didMoveToScene() {
        print("def button touched")
        isUserInteractionEnabled = true
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(DefenseNode.defBtnTouched), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
