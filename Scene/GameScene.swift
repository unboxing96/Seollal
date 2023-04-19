//  GameScene.swift

import Foundation
import SpriteKit
import SwiftUI
import CoreGraphics


class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player = Player()
    private var joystick: Joystick!
    private var obstacles: [Obstacle] = []
    private var items: [Item] = []
    private var lastUpdateTime: TimeInterval = 0
    private var mapSections: [MapSection] = []
    private var worldNode: SKNode!
    let mapScale: CGFloat = 0.15
    private var cameraNode: SKCameraNode = SKCameraNode()
    private let playerSpeed: CGFloat = 200
    private var collectedItems: Int = 0
    var itemStatusLabel: UILabel!
    var backgroundSky: SKSpriteNode!
    var backgroundImage: SKSpriteNode!
    var containerNode: SKNode!
    let safeZoneRadius: CGFloat = 200
    private var miniMap: SKNode!


    
    override func didMove(to view: SKView) {
            
        setupWorldNode()
        setupPlayer()
        setupObstaclesAndItems()
        setupCamera()
        setupCameraConstraints()
        setupJoystick()
//        setupMapEdge()
        setupMiniMap() // Call this after setupObstaclesAndItems
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let itemStatusLabel = UILabel(frame: CGRect(x: view.frame.width - 180, y: 30, width: 140, height: 40))
        itemStatusLabel.textAlignment = .right
        itemStatusLabel.textColor = .white
        itemStatusLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        itemStatusLabel.text = "Items: \(collectedItems)/4"
        view.addSubview(itemStatusLabel)
        
        self.itemStatusLabel = itemStatusLabel
        
        backgroundSky = SKSpriteNode(imageNamed: "start_night")
        backgroundSky.alpha = CGFloat(1)
        backgroundSky.zPosition = -2000
        cameraNode.addChild(backgroundSky)
        
        backgroundImage = SKSpriteNode(imageNamed: "start_moon")
        backgroundImage.position = CGPoint(x: view.frame.minX , y: -view.frame.midY - 150)
        backgroundImage.zPosition = -1000
        backgroundImage.alpha = CGFloat(0.7)
        cameraNode.addChild(backgroundImage)

        let messagePosition = CGPoint(x: size.width / 2, y: size.height / 2)
        showMessage(at: messagePosition)
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
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = player.position

        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        let dx = joystick.velocity.x * playerSpeed * CGFloat(dt)
        let dy = joystick.velocity.y * playerSpeed * CGFloat(dt)

        player.physicsBody?.applyForce(CGVector(dx: dx * 2.0, dy: dy * 2.0))

        let xMin = -size.width * 2 + player.size.width / 2
        let xMax = size.width * 2 - player.size.width / 2
        let yMin = -size.height * 2 + player.size.height / 2
        let yMax = size.height * 2 - player.size.height / 2

        player.position.x = min(max(player.position.x, xMin), xMax)
        player.position.y = min(max(player.position.y, yMin), yMax)
        
        let scaleFactor = CGFloat(0.03) // This should be the same value as used in setupMiniMap()
        miniMap.position = CGPoint(x: size.width / 2 - 120, y: -size.height / 2 + 120) // Change this line to move mini map to bottom-left side

        // Update miniPlayer position on the miniMap
        if let miniPlayer = miniMap.childNode(withName: "miniPlayer") as? SKShapeNode {
            miniPlayer.position = CGPoint(x: player.position.x * scaleFactor, y: player.position.y * scaleFactor)
        }
    }
    
    func showMessage(at position: CGPoint) {
        let label = SKSpriteNode(imageNamed: "game_caution")
        label.setScale(0.9)
        cameraNode.addChild(label)

        // Animations
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        let waitAction = SKAction.wait(forDuration: 2.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeAction])

        label.run(sequence)
    }

    
    private func handleCollision(player: SKSpriteNode, obstacle: Obstacle) {
        let bounceVector = CGVector(dx: (player.position.x - obstacle.position.x) * 0.1, dy: (player.position.y - obstacle.position.y) * 0.1)
        player.physicsBody?.applyImpulse(bounceVector)
    }
    
    private func handleItemCollision(player: SKSpriteNode, item: Item) {
        item.removeFromParent()
        collectedItems += 1
        updateItemStatusLabel()
        updateMiniMapItemStatus(for: item)

        if collectedItems == 4 {
            presentItemModal(for: item, completionHandler: {
                self.showGameEndView()
            })
        } else {
            presentItemModal(for: item)
        }
    }
    
    private func updateMiniMapItemStatus(for item: Item) {
        if let itemName = item.name, let miniItem = miniMap.childNode(withName: "miniItem-\(itemName)") as? SKShapeNode {
            miniItem.removeFromParent() // Remove the miniItem from the miniMap when the item is collected
        }
    }

    private func handleMapEdgeCollision(player: Player) {
        let bounceVector = CGVector(dx: -(player.physicsBody?.velocity.dx ?? 0) * 0.2, dy: -(player.physicsBody?.velocity.dy ?? 0) * 0.2)
        player.physicsBody?.applyImpulse(bounceVector)
    }
    
    private func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        worldNode.addChild(player)
    }

    
    private func setupJoystick() {
        joystick = Joystick()
        
        let joystickPadding: CGFloat = 100
        let joystickPosition = CGPoint(x: -size.width / 2 + joystickPadding + joystick.radius, y: -size.height / 2 + joystickPadding + joystick.radius)
        joystick.position = joystickPosition
        
        cameraNode.addChild(joystick) // Add the joystick to the cameraNode
    }
    
    private func setupObstaclesAndItems() {
        let numberOfClouds = 30 // Adjust this value as needed
        let numberOfObstacles = 20 // Adjust this value as needed

        let edgeSize = CGSize(width: size.width * 2, height: size.height * 2)
        let playerPosition = CGPoint(x: size.width / 2, y: size.height / 2)
        let safeDistance: CGFloat = 100 // Adjust this value based on your desired minimum distance from the player

        func isPositionSafe(position: CGPoint) -> Bool {
            return position.distance(to: playerPosition) >= safeDistance
        }

        // Add this code to create the items and place them outside of obstacles
        let itemArray: [Item] = [Item1(), Item2(), Item3(), Item4()]
        for item in itemArray {
            var position: CGPoint
            repeat {
                position = CGPoint(x: CGFloat.random(in: -edgeSize.width...edgeSize.width), y: CGFloat.random(in: -edgeSize.height...edgeSize.height))
            } while !isPositionOutsideObstacles(position: position) || !isPositionSafe(position: position)
            item.position = position
            worldNode.addChild(item)
            items.append(item) // Add this line to store the item in the items array
        }

        for _ in 0..<numberOfClouds {
            let cloud = Cloud()
            cloud.position = CGPoint(x: CGFloat.random(in: -edgeSize.width...edgeSize.width), y: CGFloat.random(in: -edgeSize.height...edgeSize.height))
            cloud.zPosition = -1
            cloud.setScale(CGFloat.random(in: 0.5...1.5))
            cloud.alpha = CGFloat.random(in: 0.3...1.0)
            worldNode.addChild(cloud)
        }

        for _ in 0..<numberOfObstacles {
            var position: CGPoint
            repeat {
                position = CGPoint(x: CGFloat.random(in: -edgeSize.width...edgeSize.width), y: CGFloat.random(in: -edgeSize.height...edgeSize.height))
            } while !isPositionSafe(position: position)
            let obstacle = Obstacle()
            obstacle.position = position
            worldNode.addChild(obstacle)
            obstacles.append(obstacle) // Add this line to store the obstacle in the obstacles array
        }
    }



    private func isPositionOutsideObstacles(position: CGPoint) -> Bool {
        for obstacle in obstacles {
            if obstacle.contains(position) {
                return false
            }
        }
        return true
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
        let edgeSize = CGSize(width: size.width * mapScale * 2, height: size.height * mapScale * 2)

        let leftEdge = SKNode()
        leftEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -edgeSize.width, y: -edgeSize.height), to: CGPoint(x: -edgeSize.width, y: edgeSize.height))
        leftEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        leftEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(leftEdge)

        let topEdge = SKNode()
        topEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -edgeSize.width, y: edgeSize.height), to: CGPoint(x: edgeSize.width, y: edgeSize.height))
        topEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        topEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(topEdge)

        let rightEdge = SKNode()
        rightEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: edgeSize.width, y: -edgeSize.height), to: CGPoint(x: edgeSize.width, y: edgeSize.height))
        rightEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        rightEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(rightEdge)

        let bottomEdge = SKNode()
        bottomEdge.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -edgeSize.width, y: -edgeSize.height), to: CGPoint(x: edgeSize.width, y: -edgeSize.height))
        bottomEdge.physicsBody?.categoryBitMask = PhysicsCategory.mapEdge
        bottomEdge.physicsBody?.collisionBitMask = PhysicsCategory.player
        worldNode.addChild(bottomEdge)
    }
    
    private func setupMiniMap() {
        miniMap = SKNode()
        miniMap.zPosition = 1000
        miniMap.position = CGPoint(x: size.width / 2 - 120, y: size.height / 2 - 120)
        cameraNode.addChild(miniMap)
            
        // Add a background for the minimap
        let miniMapBackground = SKShapeNode(rectOf: CGSize(width: size.width * mapScale, height: size.height * mapScale))
        miniMapBackground.fillColor = .black
        miniMapBackground.alpha = 0.6
        miniMap.addChild(miniMapBackground)
            
        // Add the player to the minimap
        let miniPlayer = SKShapeNode(circleOfRadius: 4)
        miniPlayer.fillColor = .blue
        miniPlayer.position = CGPoint.zero
        miniPlayer.zPosition = 1001
        miniPlayer.name = "miniPlayer"
        miniMap.addChild(miniPlayer)
        
        // Create the MiniMap title label
        let titleLabel = SKLabelNode(fontNamed: "Arial")
        titleLabel.text = "Mini map"
        titleLabel.fontSize = 18
        titleLabel.fontColor = SKColor.white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .bottom
        titleLabel.position = CGPoint(x: 0, y: miniMapBackground.frame.size.height / 2 + 5)
        miniMap.addChild(titleLabel)
            
        // Add the items to the minimap
        for (index, item) in items.enumerated() {
            let miniItem = SKShapeNode(circleOfRadius: 4)
            miniItem.fillColor = .yellow
            let scaleFactor = CGFloat(0.03)
            miniItem.position = CGPoint(x: item.position.x * scaleFactor, y: item.position.y * scaleFactor)
            miniItem.zPosition = 1001
            miniItem.name = "miniItem-\(index)"
            miniMap.addChild(miniItem)
        }

        // Add the obstacles to the minimap
        for obstacle in obstacles {
            let miniObstacle = SKShapeNode(circleOfRadius: 2)
            miniObstacle.fillColor = .clear
            miniObstacle.strokeColor = .white
            let scaleFactor = CGFloat(0.03)
            miniObstacle.position = CGPoint(x: obstacle.position.x * scaleFactor, y: obstacle.position.y * scaleFactor)
            miniObstacle.zPosition = 1001
            miniMap.addChild(miniObstacle)
        }

        // Add the obstacles to the minimap
        for obstacle in obstacles {
            let miniObstacle = SKShapeNode(circleOfRadius: 2)
            miniObstacle.fillColor = .clear
            miniObstacle.strokeColor = .white // Add this line to give the obstacles an outline
            let scaleFactor = CGFloat(0.03) // Adjust this value to control the scale of the minimap
            miniObstacle.position = CGPoint(x: obstacle.position.x * scaleFactor, y: obstacle.position.y * scaleFactor)
            miniObstacle.zPosition = 1001
            miniMap.addChild(miniObstacle)
        }
    }


    private func setupCameraConstraints() {
        let xRange = SKRange(lowerLimit: -size.width * 2 + size.width / 2, upperLimit: size.width * 2 - size.width / 2)
        let yRange = SKRange(lowerLimit: -size.height * 2 + size.height / 2, upperLimit: size.height * 2 - size.height / 2)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        cameraNode.constraints = [constraint]
    }
    
    // Update the presentItemModal function to include the completionHandler
    private func presentItemModal(for item: Item, completionHandler: (() -> Void)? = nil) {
        guard let view = self.view else { return }
            
        let hostingController = UIHostingController(rootView: AnyView(EmptyView().background(Color.clear)))
            
        hostingController.rootView = AnyView(ItemModalView(item: item, image: item.uiImage(), onDismiss: {
            view.isPaused = false
            self.joystick.velocity = .zero // Add this line to reset the joystick's velocity
            self.lastUpdateTime = TimeInterval(Date().timeIntervalSinceReferenceDate)
            hostingController.dismiss(animated: true)
            completionHandler?() // Add this line to call the completionHandler after dismissing the modal
        }))
            
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Set the background color to white with 80% opacity

        view.isPaused = true
        view.window?.rootViewController?.present(hostingController, animated: true)
    }



    private func showGameEndView() {
//        resetGame()
        
        // Add this code before transitioning to another scene or in your game over function
        itemStatusLabel.removeFromSuperview()

        guard let view = self.view else { return }
        
        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        
        hostingController.rootView = AnyView(GameEndView())

        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        
        view.isPaused = true
        view.window?.rootViewController?.present(hostingController, animated: true, completion: nil)
    }

    private func resetGame() {
        updateItemStatusLabel()
        collectedItems = 0
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
    static let mapEdge: UInt32 = 0x1 << 4 // Add this line for a separate category for map edges
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = self.x - point.x
        let yDistance = self.y - point.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}
