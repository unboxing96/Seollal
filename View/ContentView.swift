// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var isGameActive = false

    var body: some View {
        VStack {
            if isGameActive {
                GameView()
            } else {
                Button(action: {
                    isGameActive = true
                }) {
                    Text("Start Game")
                        .font(.largeTitle)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
