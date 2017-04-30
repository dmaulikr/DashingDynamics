//
//  ZoneManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneManager {
    
    var scene: GameScene!
    var zones = [Zone]()
    enum ZoneType {
        case NormalZone
        case ChallengeZone
    }
    var lastZoneType = ZoneType.NormalZone
    var currentZone: Zone?
    var currentZoneExited = false
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Add Normal Zone
        zones.append(ZoneNormal(scene: scene, begXPos: 0, begYPos: 0))
        let firstPlatform = zones[0].platformBlocksManager.blocks[0].entities[0] as! Platform
        let texture = SKTexture(imageNamed: "bigPlatform2")
        texture.filteringMode = .nearest
        firstPlatform.component(ofType: SpriteComponent.self)?.node.texture = texture
        firstPlatform.activated = true
    }
    
    func update(deltaTime seconds: TimeInterval) {
        checkIfZoneNeedsToBeAdded()
        checkIfZoneNeedsToBeRemoved()
        
        checkIfChallengeZoneEntered()
        checkIfChallengeZoneExited()
        
        // Update through all entities
        for zone in zones {
            for block in zone.platformBlocksManager.blocks {
                for entity in block.entities {
                    entity.update(deltaTime: seconds)
                }
            }
        }
    }
    
    func checkIfZoneNeedsToBeAdded() {
        let yPosOfPlayer = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let begYPosOfLastZone = zones.last?.begYPos
        if yPosOfPlayer! > begYPosOfLastZone! {
            addZone()
        }
    }
    
    func checkIfZoneNeedsToBeRemoved() {
        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
        if zones.count >= 2 {
            let begYPosOfSecondZone = zones[1].begYPos
            if yPosOfBottomOfScreen >= begYPosOfSecondZone! {
                zones.first?.platformBlocksManager.removeAllBlocks()
                zones.removeFirst()
            }
        }
    }
    
    func addZone() {
        let zoneFirstXPos = (zones.last?.platformBlocksManager.begXPos)!
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!

        
        if lastZoneType == ZoneType.NormalZone {
            addRandomChallengeZone()
            lastZoneType = .ChallengeZone
        } else {
            zones.append(ZoneNormal(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
            lastZoneType = .NormalZone
        }
    }
    
    func addRandomChallengeZone() {
        let zoneFirstXPos = (zones.last?.platformBlocksManager.begXPos)!
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!

        let randomize = arc4random_uniform(3)
        switch randomize {
        case 0:
            zones.append(ZoneChallengeMagnet(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
        case 1:
            zones.append(ZoneChallengeVisibility(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
        case 2:
            zones.append(ZoneChallengeLongJump(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
        default:
            break
        }
    }
    
    func checkIfChallengeZoneEntered() {
        // Get current zone and platform the player is on
        var currentPlatformSprite: SKSpriteNode!
        let playerStateMachine = scene.player?.component(ofType: MovementComponent.self)?.stateMachine
        if playerStateMachine?.currentState is LandedState {
            if let currentPlatform = playerStateMachine?.state(forClass: LandedState.self)?.currentPlatform {
                
                // Activate enter event for zone
                currentPlatformSprite = currentPlatform as! SKSpriteNode
                for zone in zones {
                    let firstPlatSprite = zone.firstPlatform.component(ofType: SpriteComponent.self)?.node
                    if firstPlatSprite == currentPlatformSprite {
                        if zone is ZoneChallengeMagnet ||
                           zone is ZoneChallengeLongJump ||
                           zone is ZoneChallengeVisibility {
                            zone.enterEvent()
                            currentZone = zone
                            break
                        }
                    }
                }
            }
        }
    }
    
    func checkIfChallengeZoneExited() {
        if currentZone != nil {
            let yPosOfPlayer = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
            let begYPosOfcurrentZone = currentZone?.begYPos
            let endYPosOfcurrentZone = begYPosOfcurrentZone! + (currentZone?.size.height)!
            if yPosOfPlayer! > endYPosOfcurrentZone {
                currentZone?.exitEvent()
            }
        }
    }
    
}
