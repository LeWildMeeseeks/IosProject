//
//  Types.swift
//  IOSProject
//
//  Created by Giane Carlo Go on 2017-06-23.
//  Copyright © 2017 IOSproj. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:      UInt32 = 0
    static let All:       UInt32 = 0xFFFFFFFF
    static let Edge:      UInt32 = 0b1
    static let Player:    UInt32 = 0b10
    static let Bug:       UInt32 = 0b100
    static let FireBug:   UInt32 = 0b1000
    static let Breakable: UInt32 = 0b10000
}
