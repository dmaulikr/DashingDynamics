//
//  GameScene+Physics.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/24/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

protocol PlatformLandingDelegate {
    func markForLanding(platform: SKNode)
}

extension GameScene: SKPhysicsContactDelegate {
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        let firstBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyB : contact.bodyA
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            physicsContactCount += 1
            
            guard let node = secondBody.node else { break }
            platformLandingDelegate?.markForLanding(platform: node)
            
        default:
            break
        }
        
        player?.isOnPlatform = physicsContactCount == 0 ? false : true
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody  = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyB : contact.bodyA
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (GameplayConfiguration.PhysicsBitmask.player, GameplayConfiguration.PhysicsBitmask.platform):
            physicsContactCount -= 1
            
        default:
            break
        }

        player?.isOnPlatform = physicsContactCount == 0 ? false : true
    }
}
