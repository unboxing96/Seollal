import SpriteKit

class Item: SKSpriteNode {
    var itemName: String
    var itemDescription: String
    
    init(textureNamed: String, itemName: String, itemDescription: String) {
        self.itemName = itemName
        self.itemDescription = itemDescription
        let texture = SKTexture(imageNamed: textureNamed)
        let itemSize = CGSize(width: 250, height: 250) // Set the size for all items here
        super.init(texture: texture, color: .clear, size: itemSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiImage() -> UIImage {
        return self.texture!.uiImage()
    }
}

extension SKTexture {
    func uiImage() -> UIImage {
        let view = SKView(frame: CGRect(origin: .zero, size: self.size()))
        let scene = SKScene(size: self.size())
        let spriteNode = SKSpriteNode(texture: self)
        spriteNode.position = CGPoint(x: self.size().width / 2, y: self.size().height / 2)
        scene.addChild(spriteNode)
        view.presentScene(scene)
        view.backgroundColor = .white // Set the background color to white
        
        UIGraphicsBeginImageContextWithOptions(self.size(), false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



class Item1: Item {
    init() {
        super.init(textureNamed: "item1_image", itemName: "Item 1", itemDescription: "Description for Item 1")
        self.itemName = "Item 1"
        self.itemDescription = "Description for Item 1"
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.item
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.isDynamic = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item2: Item {
    init() {
        super.init(textureNamed: "item2_image", itemName: "Item 2", itemDescription: "Description for Item 2")
        self.itemName = "Item 2"
        self.itemDescription = "Description for Item 2"
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.item
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.isDynamic = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item3: Item {
    init() {
        super.init(textureNamed: "item3_image", itemName: "Item 3", itemDescription: "Description for Item 3")
        self.itemName = "Item 3"
        self.itemDescription = "Description for Item 3"
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.item
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.isDynamic = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item4: Item {
    init() {
        super.init(textureNamed: "item4_image", itemName: "Item 4", itemDescription: "Description for Item 4")
        self.itemName = "Item 4"
        self.itemDescription = "Description for Item 4"
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.item
        physicsBody?.collisionBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
