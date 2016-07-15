//
//  PlatformBlock.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformBlock: SKNode {
    
    var platforms = [Platform]()
    var size: CGSize!
    var nextBlockFirstPlatformXPos: CGFloat!
    
    override init() {
        super.init()
        print("PlatformBlock Object Created")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
