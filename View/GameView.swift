//
//  GameView.swift
//  SeollalGame
//
//  Created by kimpepe on 2023/04/12.
//

import Foundation
import SwiftUI
import SpriteKit

struct GameView: View {
    var body: some View {
        SpriteView(scene: GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
            .edgesIgnoringSafeArea(.all)
    }
}
