//
//  Item.swift
//  SeollalGame
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit
import SwiftUI

class Item: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "item") // Change the image to an item image
        super.init(texture: texture, color: .clear, size: texture.size())
        setupPhysicsBody()
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = 8
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
