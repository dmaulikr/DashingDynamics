//
//  SKDot.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 3/19/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    static func dot(position: CGPoint = CGPoint.zero) -> SKSpriteNode {
        let dot = SKSpriteNode(color: .red, size: CGSize.one())
        dot.zPosition = CGFloat.greatestFiniteMagnitude
        dot.position = position
        return dot
    }
}

extension CGSize {
    static func one() -> CGSize {
        return CGSize(width: 1, height: 1)
    }
}

