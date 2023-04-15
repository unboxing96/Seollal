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
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.edge // Change "mapEdge" to "edge" in this line
        physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.edge // Change "mapEdge" to "edge" in this line
        
        physicsBody?.restitution = 0.5 // Add this line to make the player bounce off edges
        physicsBody?.linearDamping = 2.0 // Add this line to control the player's speed
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
        physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.mapEdge // Update this line to include PhysicsCategory.mapEdge
        physicsBody?.restitution = 1.0
    }
}
