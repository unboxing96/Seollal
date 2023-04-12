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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = true
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 2
        physicsBody?.contactTestBitMask = 2 | 4
    }
}
