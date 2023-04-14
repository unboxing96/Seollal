//
//  Player.swift
//  
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: .clear, size: texture.size())
        setupPhysicsBody()
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.mapEdge
        physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.mapEdge
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 2
        physicsBody?.collisionBitMask = 2
    }
}
