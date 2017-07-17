//
//  GameSceneStateTutorial.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/16/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TapDelegate {
    func tapGesture(at location: CGPoint)
}

class GameSceneStateTutorial: GKState, TapDelegate {
    
    unowned let scene : GameScene
    var slideView: UIImageView // SKSpriteNode
    
    let slides = [
        UIImage(named: "1.png"),
        UIImage(named: "2.png")
    ]
    
    init(scene: GameScene) {
        self.scene = scene
        self.slideView = UIImageView(image: slides.first!)
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.view?.addSubview(slideView)
        scene.view?.isPaused = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
    
    func tapGesture(at location: CGPoint) {
        print(location)
    }
}
