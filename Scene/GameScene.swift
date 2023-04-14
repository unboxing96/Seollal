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
    
    // camera
    private var cameraNode: SKCameraNode = SKCameraNode()

    // speed
    private let playerSpeed: CGFloat = 200 // Adjust this value to control the player's speed


    
    override func didMove(to view: SKView) {
        setupWorldNode()
        setupPlayer()
        setupObstaclesAndItems()
        setupCamera()
        setupJoystick()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1) // Weaker gravity
    }



    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        if let playerNode = nodeA as? Player, let obstacleNode = nodeB as? Obstacle {
            handleCollision(player: playerNode, obstacle: obstacleNode)
        } else if let playerNode = nodeB as? Player, let obstacleNode = nodeA as? Obstacle {
            handleCollision(player: playerNode, obstacle: obstacleNode)
        } else if let playerNode = nodeA as? Player, let itemNode = nodeB as? Item {
            handleItemCollision(player: playerNode, item: itemNode)
        } else if let playerNode = nodeB as? Player, let itemNode = nodeA as? Item {
            handleItemCollision(player: playerNode, item: itemNode)
        }
    }

    
    private func handleCollision(player: SKSpriteNode, obstacle: Obstacle) {
        // Player bounces off the obstacle
        let bounceVector = CGVector(dx: (player.position.x - obstacle.position.x), dy: (player.position.y - obstacle.position.y))
        player.physicsBody?.applyImpulse(bounceVector)
    }
    
    private func handleItemCollision(player: SKSpriteNode, item: Item) {
        // Float a modal when the player touches an item
        item.removeFromParent() // Remove the item from the game world
        // Implement the logic for floating a modal, e.g., show a message, update the score, or play a sound effect
    }
    
    private func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        worldNode.addChild(player)
        setupPlayerConstraints()
    }

    
    private func setupJoystick() {
        joystick = Joystick()
        
        let joystickPadding: CGFloat = 50
        let joystickPosition = CGPoint(x: -size.width / 2 + joystickPadding + joystick.radius, y: -size.height / 2 + joystickPadding + joystick.radius)
        joystick.position = joystickPosition
        
        cameraNode.addChild(joystick) // Add the joystick to the cameraNode
    }




    
    private func setupObstaclesAndItems() {
        let numberOfClouds = 50 // Adjust this value as needed
        let numberOfObstacles = 40 // Adjust this value as needed

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
    
    private func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
    }
    
    private func setupWorldNode() {
        worldNode = SKNode()
        addChild(worldNode)
    }
    
    private func setupPlayerConstraints() {
        let xRange = SKRange(lowerLimit: -size.width * 4 + player.size.width / 2, upperLimit: size.width * 4 - player.size.width / 2)
        let yRange = SKRange(lowerLimit: -size.height * 4 + player.size.height / 2, upperLimit: size.height * 4 - player.size.height / 2)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        player.constraints = [constraint]
    }


    
    override func update(_ currentTime: TimeInterval) {
        // camera
        cameraNode.position = player.position
        
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        let dx = joystick.velocity.x * playerSpeed * CGFloat(dt)
        let dy = joystick.velocity.y * playerSpeed * CGFloat(dt)

        // Apply a stronger force to the player's physics body based on joystick input
        player.physicsBody?.applyForce(CGVector(dx: dx, dy: dy)) // Decreased impulse power

        // Ensure the player doesn't move beyond the map boundaries
        player.position.x = min(max(player.position.x, -size.width * 4), size.width * 4)
        player.position.y = min(max(player.position.y, -size.height * 4), size.height * 4)
        
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
