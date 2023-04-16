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
    
    // map size
    let mapScale: CGFloat = 0.05 // Change this value to reduce the size of the map

    // camera
    private var cameraNode: SKCameraNode = SKCameraNode()

    // speed
    private let playerSpeed: CGFloat = 200 // Adjust this value to control the player's speed
    
    // count items
    private var collectedItems: Int = 0
    private var itemStatusLabel: SKLabelNode!

    // bgImage
    let backgroundImage = SKSpriteNode()


    
    override func didMove(to view: SKView) {
        setupWorldNode()
        setupPlayer()
        setupObstaclesAndItems()
        setupCamera()
        setupCameraConstraints()
        setupJoystick()
        setupMapEdge()
        createBackgroundImage()
        createItemStatusWindow()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1) // Weaker gravity
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        if let playerNode = nodeA as? Player, let itemNode = nodeB as? Item {
            handleItemCollision(player: playerNode, item: itemNode)
        } else if let playerNode = nodeB as? Player, let itemNode = nodeA as? Item {
            handleItemCollision(player: playerNode, item: itemNode)
        }
    }

    
    private func handleCollision(player: SKSpriteNode, obstacle: Obstacle) {
        let bounceVector = CGVector(dx: (player.position.x - obstacle.position.x) * 0.1, dy: (player.position.y - obstacle.position.y) * 0.1)
        player.physicsBody?.applyImpulse(bounceVector)
    }
    
    private func handleItemCollision(player: SKSpriteNode, item: Item) {
        item.removeFromParent()
        collectedItems += 1
        updateItemStatusLabel()

        if collectedItems == items.count {
            presentItemModal(for: item, completionHandler: {
                self.showGameEndView()
            })
        } else {
            presentItemModal(for: item)
        }
    }


    private func handleMapEdgeCollision(player: Player) {
        let bounceVector = CGVector(dx: -(player.physicsBody?.velocity.dx ?? 0) * 0.2, dy: -(player.physicsBody?.velocity.dy ?? 0) * 0.2)
        player.physicsBody?.applyImpulse(bounceVector)
    }

//
//    private func showModal(for itemName: String) {
//        // Implement the code to display a modal with information about the itemName
//        // This will depend on your UI implementation
//    }
    
    
    private func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        worldNode.addChild(player)
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
        let numberOfItems = 4 // Adjust this value as needed

        // Add this code to create the items and place them outside of obstacles
        let items: [Item] = [Item1(), Item2(), Item3(), Item4()]
        for item in items {
            var position: CGPoint
            repeat {
                position = CGPoint(x: CGFloat.random(in: -size.width * 4...size.width * 4), y: CGFloat.random(in: -size.height * 4...size.height * 4))
                item.position = position
            } while !isPositionOutsideObstacles(position: position)
            worldNode.addChild(item)
        }

        for _ in 0..<numberOfClouds {
            let cloud = Cloud()
            cloud.position = CGPoint(x: CGFloat.random(in: -size.width * 4...size.width * 4), y: CGFloat.random(in: -size.height * 4...size.height * 4))
            cloud.zPosition = -1
            cloud.setScale(CGFloat.random(in: 0.5...1.5))
            cloud.alpha = CGFloat.random(in: 0.3...1.0)
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
    

    private func setupMapEdge() {
        let leftEdge = SKNode()
        leftEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width * mapScale, y: -size.height * mapScale), to: CGPoint(x: -size.width * mapScale, y: size.height * mapScale))
        leftEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        leftEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(leftEdge)

        let topEdge = SKNode()
        topEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width * mapScale, y: size.height * mapScale), to: CGPoint(x: size.width * mapScale, y: size.height * mapScale))
        topEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        topEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(topEdge)

        let rightEdge = SKNode()
        rightEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: size.width * mapScale, y: size.height * mapScale), to: CGPoint(x: size.width * mapScale, y: -size.height * mapScale))
        rightEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        rightEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(rightEdge)

        let bottomEdge = SKNode()
        bottomEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: size.width * mapScale, y: -size.height * mapScale), to: CGPoint(x: -size.width * mapScale, y: -size.height * mapScale))
        bottomEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        bottomEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(bottomEdge)
    }




    private func isPositionOutsideObstacles(position: CGPoint) -> Bool {
        for obstacle in obstacles {
            if obstacle.contains(position) {
                return false
            }
        }
        return true
    }

    
    override func update(_ currentTime: TimeInterval) {
        // camera
        cameraNode.position = player.position
        
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        let dx = joystick.velocity.x * playerSpeed * CGFloat(dt)
        let dy = joystick.velocity.y * playerSpeed * CGFloat(dt)
        
        // Update itemStatusLabel position
        itemStatusLabel.position = CGPoint(x: cameraNode.position.x + size.width / 2 - itemStatusLabel.frame.width / 2 - 10, y: cameraNode.position.y + size.height / 2 - itemStatusLabel.frame.height / 2 - 10)

        backgroundImage.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y)
        
        // Apply a stronger force to the player's physics body based on joystick input
        player.physicsBody?.applyForce(CGVector(dx: dx * 2.0, dy: dy * 2.0))
        
        // Ensure the player doesn't move beyond the map boundaries
        let xMin = -size.width * 4 + player.size.width / 2
        let xMax = size.width * 4 - player.size.width / 2
        let yMin = -size.height * 4 + player.size.height / 2
        let yMax = size.height * 4 - player.size.height / 2
        
        player.position.x = min(max(player.position.x, xMin), xMax)
        player.position.y = min(max(player.position.y, yMin), yMax)
    }
    
//        // Ensure the player doesn't move beyond the map boundaries
//        player.position.x = min(max(player.position.x, -size.width * 4), size.width * 4)
//        player.position.y = min(max(player.position.y, -size.height * 4), size.height * 4)
        

    private func setupCameraConstraints() {
        let xRange = SKRange(lowerLimit: -size.width * 4 + size.width / 2, upperLimit: size.width * 4 - size.width / 2)
        let yRange = SKRange(lowerLimit: -size.height * 4 + size.height / 2, upperLimit: size.height * 4 - size.height / 2)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        cameraNode.constraints = [constraint]
    }

    
    private func presentItemModal(for item: Item, completionHandler: (() -> Void)? = nil) {
        guard let view = self.view else { return }
        
        let hostingController = UIHostingController(rootView: AnyView(EmptyView().background(Color.clear)))

        hostingController.rootView = AnyView(ItemModalView(item: item, onDismiss: {
            view.isPaused = false
            self.joystick.velocity = .zero // Add this line to reset the joystick's velocity
            self.lastUpdateTime = TimeInterval(Date().timeIntervalSinceReferenceDate)
            hostingController.dismiss(animated: true)
        }))

        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        
        view.isPaused = true
        view.window?.rootViewController?.present(hostingController, animated: true)
    }

    
    private func createBackgroundImage() {
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 4)
        backgroundImage.zPosition = -2
        backgroundImage.alpha = 0.5
        addChild(backgroundImage)
    }
    
    private func createItemStatusWindow() {
        itemStatusLabel = SKLabelNode(fontNamed: "Arial")
        itemStatusLabel.text = "Items: \(collectedItems)/4"
        itemStatusLabel.fontSize = 20
        itemStatusLabel.fontColor = .white
        itemStatusLabel.horizontalAlignmentMode = .right
        itemStatusLabel.position = CGPoint(x: size.width / 2 - itemStatusLabel.frame.width / 2 - 10, y: size.height / 2 - itemStatusLabel.frame.height / 2 - 10)
        cameraNode.addChild(itemStatusLabel) // Add the itemStatusLabel to the cameraNode
    }
    
    private func showGameEndView() {
        resetGame()

        guard let view = self.view else { return }
        
        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        
        hostingController.rootView = AnyView(GameEndView())

        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        
        view.isPaused = true
        view.window?.rootViewController?.present(hostingController, animated: true, completion: nil)
    }

    
    private func resetGame() {
        collectedItems = 0
        updateItemStatusLabel()
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)

        for item in items {
            if item.parent == nil {
                worldNode.addChild(item)
            }
        }
    }



    private func updateItemStatusLabel() {
        itemStatusLabel.text = "Items: \(collectedItems)/4"
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

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let obstacle: UInt32 = 0x1 << 1
    static let item: UInt32 = 0x1 << 3
    static let edge: UInt32 = 0x1 << 3
    static let mapEdge: UInt32 = 0x1 << 4 // Add this line for a separate category for map edges
}
