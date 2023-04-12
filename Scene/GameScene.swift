//
//  GameScene.swift
//  SeollalGame
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player = Player()
    private var joystick: Joystick!
    private var obstacles: [Obstacle] = []
    private var items: [Item] = []
    private var lastUpdateTime: TimeInterval = 0
    
    // map
    private var mapSections: [MapSection] = []
    private var worldNode: SKNode!
    
    override func didMove(to view: SKView) {
        setupWorldNode()
        setupPlayer()
        setupJoystick()
        setupObstaclesAndItems()
        physicsWorld.contactDelegate = self
    }
    
    private func setupWorldNode() {
        worldNode = SKNode()
        addChild(worldNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        if let playerNode = nodeA as? Player, let obstacleNode = nodeB as? Obstacle {
            handleCollision(player: playerNode, obstacle: obstacleNode)
        } else if let playerNode = nodeB as? Player, let obstacleNode = nodeA as? Obstacle {
            handleCollision(player: playerNode, obstacle: obstacleNode)
        }
    }
    
    private func handleCollision(player: SKSpriteNode, obstacle: Obstacle) {
        // Handle the collision between the player and the obstacle.
        // For example, you can stop the game, play a sound effect, or display a game over message.
        print("Player collided with an obstacle")
    }

    
    private func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        worldNode.addChild(player)
    }
    
    private func setupJoystick() {
        joystick = Joystick()
        joystick.position = CGPoint(x: 100, y: 100)
        addChild(joystick)
    }
    
    private func setupObstaclesAndItems() {
        let numberOfClouds = 50 // Adjust this value as needed
        let numberOfObstacles = 20 // Adjust this value as needed

        for _ in 0..<numberOfClouds {
            let cloud = Cloud()
            cloud.position = CGPoint(x: CGFloat.random(in: -size.width * 4...size.width * 4), y: CGFloat.random(in: -size.height * 4...size.height * 4))
            worldNode.addChild(cloud)
        }

        for _ in 0..<numberOfObstacles {
            let obstacle = Obstacle()
            obstacle.position = CGPoint(x: CGFloat.random(in: -size.width * 4...size.width * 4), y: CGFloat.random(in: -size.height * 4...size.height * 4))
            worldNode.addChild(obstacle)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        let dx = joystick.velocity.x * CGFloat(dt)
        let dy = joystick.velocity.y * CGFloat(dt)

        worldNode.position.x -= dx
        worldNode.position.y -= dy

        // Ensure the worldNode doesn't move beyond the map boundaries
        worldNode.position.x = min(max(worldNode.position.x, -size.width * 4), size.width * 4)
        worldNode.position.y = min(max(worldNode.position.y, -size.height * 4), size.height * 4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.joystickTouchesBegan(touches, with: event)
    }
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.joystickTouchesMoved(touches, with: event)
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.joystickTouchesEnded(touches, with: event)
    }
    
}
