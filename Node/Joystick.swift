//
//  Joystick.swift
//  SeollalGame
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit
import SwiftUI

import SpriteKit

class Joystick: SKNode {
    var velocity = CGPoint.zero
    private var controlNode: SKShapeNode!

    override init() {
        super.init()
        setupControlNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupControlNode() {
        controlNode = SKShapeNode(circleOfRadius: 30)
        controlNode.fillColor = .red
        controlNode.strokeColor = .clear
        addChild(controlNode)
    }
    
    func joystickTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            controlNode.position = location
        }
    }
    
    func joystickTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let maxDistance: CGFloat = 50
            let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
            
            if distance < maxDistance {
                controlNode.position = location
            } else {
                let dx = location.x * maxDistance / distance
                let dy = location.y * maxDistance / distance
                controlNode.position = CGPoint(x: dx, y: dy)
            }
            
            let normalizedDistance = min(distance, maxDistance)
            velocity = CGPoint(x: location.x * normalizedDistance / maxDistance, y: location.y * normalizedDistance / maxDistance)
        }
    }
    
    func joystickTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlNode.position = CGPoint.zero
        velocity = CGPoint.zero
    }
}
