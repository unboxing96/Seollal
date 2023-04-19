import SpriteKit

class Item: SKSpriteNode {
    var itemName: String
    var itemDescription: String
    var worldNodeTexture: SKTexture
    var modalTexture: SKTexture
    
    init(worldNodeTexture: SKTexture, modalTexture: SKTexture, itemName: String, itemDescription: String) {
        self.worldNodeTexture = worldNodeTexture
        self.modalTexture = modalTexture
        self.itemName = itemName
        self.itemDescription = itemDescription
        
        let itemSize = CGSize(width: 250, height: 250) // Set the size for all items here
        super.init(texture: worldNodeTexture, color: .clear, size: itemSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiImage() -> UIImage {
        return self.modalTexture.uiImage()
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
        super.init(worldNodeTexture: SKTexture(imageNamed: "item1_image"), modalTexture: SKTexture(imageNamed: "item1_modal"), itemName: "Item1", itemDescription: "Description for Item 1")
        self.itemName = "Neolttwigi"
        self.itemDescription = """
                   Neolttwigi is a game similar to seesaw
                   If they stand on either side of the wooden board and jump,
                   the other one can go out of the moon
                   (or the world they are trapped).
                   """
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
        super.init(worldNodeTexture: SKTexture(imageNamed: "item2_image"), modalTexture: SKTexture(imageNamed: "item2_modal"), itemName: "Item 2", itemDescription: "Description for Item 2")
        self.itemName = "Burum"
        self.itemDescription = """
                There was a belief that breaking the burum in the New Year
                would prevent infectious diseases
                and keep your teeth healthy.
                """
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
        super.init(worldNodeTexture: SKTexture(imageNamed: "item3_image"), modalTexture: SKTexture(imageNamed: "item3_modal"), itemName: "Item 3", itemDescription: "Description for Item 3")
        self.itemName = "Kite flying"
        self.itemDescription = """
                Write down the bad luck on the kite
                and cut off the kite string and send it far away.
                It means to send away all the bad luck of the year and welcome good fortune.
                """
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
        super.init(worldNodeTexture: SKTexture(imageNamed: "item4_image"), modalTexture: SKTexture(imageNamed: "item4_modal"), itemName: "Item 4", itemDescription: "Description for Item 4")
        self.itemName = "Sheaf Burning"
        self.itemDescription = """
                it means “burn the house of moon”
                It's a very large campfire by village.
                It was believed that if the house of moon burned well,
                it would have a good harvest in that year.
                """
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
