import SpriteKit

class Item: SKSpriteNode {
    var image: UIImage {
        return self.texture!.uiImage()
    }
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        let itemSize = CGSize(width: 50, height: 50) // Set the size for all items here
        super.init(texture: texture, color: .clear, size: itemSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item1: Item {
    init() {
        super.init(imageNamed: "item1_image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item2: Item {
    init() {
        super.init(imageNamed: "item2_image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item3: Item {
    init() {
        super.init(imageNamed: "item3_image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Item4: Item {
    init() {
        super.init(imageNamed: "item4_image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKTexture {
    func uiImage() -> UIImage {
        let view = SKView(frame: CGRect(origin: .zero, size: self.size()))
        let size = self.size()
        let scene = SKScene(size: size)
        let spriteNode = SKSpriteNode(texture: self)
        spriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scene.addChild(spriteNode)
        view.presentScene(scene)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
