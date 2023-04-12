//
//  Obstacle.swift
//  SeollalGame
//
//  Created by kimpepe on 2023/04/12.
//

// Obstacle.swift
import SpriteKit

class Obstacle: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "obstacle")
        super.init(texture: texture, color: .clear, size: texture.size())
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        // Set physicsBody properties like categoryBitMask, collisionBitMask, and contactTestBitMask if needed
        physicsBody?.categoryBitMask = 2
        physicsBody?.contactTestBitMask = 1
        physicsBody?.collisionBitMask = 1
    }
}
