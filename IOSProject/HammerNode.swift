//
//  HammerNode.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-29.
//  Copyright © 2017 IOSproj. All rights reserved.
//
import SpriteKit

class HammerNode: SKSpriteNode, EventListenerNode {
    static let hmrBtnTouched = "hammer"
    var isAtking = false
    
    func didMoveToScene() {
        print("hammer button touched")
        isUserInteractionEnabled = true
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(HammerNode.hmrBtnTouched), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
