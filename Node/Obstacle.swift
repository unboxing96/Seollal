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
        let randomScale = CGFloat.random(in: 0.4...0.8) // Generate a random scale factor between 0.5 and 2
        let newSize = CGSize(width: texture.size().width * randomScale, height: texture.size().height * randomScale) // Calculate the new size based on the random scale factor
        super.init(texture: texture, color: .clear, size: newSize) // Pass the newSize to the super.init
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
