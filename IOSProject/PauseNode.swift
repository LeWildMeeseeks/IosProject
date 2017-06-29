//
//  PauseNode.swift
//  IOSProject
//
//  Created by Denn Mark on 2017-06-29.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

class PauseNode: SKSpriteNode, EventListenerNode {
    static let pauseBtnTouched = "pause"
    
    func didMoveToScene() {
        print("pause button touched")
        isUserInteractionEnabled = true
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(PauseNode.pauseBtnTouched), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
