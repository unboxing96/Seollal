//
//  Cloud.swift
//  
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit

class Cloud: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "cloud")
        super.init(texture: texture, color: .clear, size: texture.size())
        zPosition = -1 // This ensures the cloud is rendered behind the player and other obstacles
        setupPhysicsBody()
    }
    
    private func setupPhysicsBody() {
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = 4
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
