//
//  Extensions.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-06-23.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import SpriteKit

extension SKTexture{
    convenience init(pixelImageNamed: String){
        self.init(imageNamed: pixelImageNamed)
        self.filteringMode = .nearest
    }
}

