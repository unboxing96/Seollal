//
//  MapSection.swift
//  
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SpriteKit

class MapSection: SKNode {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        // To this:
        let mapSize = CGSize(width: 1000, height: 1000) // New size: 1/4 of the original size
        
        self.width = mapSize.width
        self.height = mapSize.height
        super.init()
        createObstaclesAndItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createObstaclesAndItems() {
        // Add clouds to the map section
//        let numberOfClouds = 20 // You can adjust this value as needed
//        for _ in 9..<numberOfClouds {
//            let cloud = Cloud()
//            cloud.position = CGPoint(x: CGFloat.random(in: 0...width), y: CGFloat.random(in: 0...height))
//            addChild(cloud)
//        }
        
        // Customize this function to generate obstacles and items for the map section
    }
}
