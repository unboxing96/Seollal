// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var isGameActive = false
    @State var degrees = 0.0

    var body: some View {
        ZStack {
            VStack {
                if isGameActive {
                    GameView()
                } else {
                    ZStack {
                        // background image
                        Image("start_night")
                        Image("start_moon")
                            .offset(y: 800)
                        
                        // title
//                        HStack{
//                            Image("start_title1")
//                                .scaleEffect(0.8)
//                                .offset(x: -30, y: -400)
//                            Image("start_title2")
//                                .scaleEffect(0.8)
//                                .offset(x: 30, y: -400)
//                        }
                        
                        // font
                        HStack{
                            Image("start_font1")
                                .scaleEffect(1.4)
                                .offset(x: -60, y: 140)
                                .rotationEffect(.degrees(-20))
                            Image("start_font2")
                                .scaleEffect(1.4)
                                .offset(x: -65, y: 100)
                                .rotationEffect(.degrees(-15))
                            Image("start_font3")
                                .scaleEffect(1.4)
                                .offset(x: -40, y: 80)
                                .rotationEffect(.degrees(-8))
                            Image("start_font4")
                                .scaleEffect(1.4)
                                .offset(x: -15, y: 80)
                            Image("start_font5")
                                .scaleEffect(1.4)
                                .offset(x: 5, y: 90)
                                .rotationEffect(.degrees(10))
                            Image("start_font6")
                                .scaleEffect(1.4)
                                .offset(x: 40, y: 115)
                                .rotationEffect(.degrees(20))
                            Image("start_font7")
                                .scaleEffect(1.4)
                                .offset(x: 70, y: 150)
                                .rotationEffect(.degrees(25))
                        }
                        
                        Button(action: {
                            isGameActive = true
                        }) {
                            VStack {
                                Image("start_click")
                                    .scaleEffect(0.5)
                                    .offset(y: -30)
                                Image("player")
                                    .rotationEffect(Angle(degrees: degrees), anchor: .center)
                                    .onAppear {
                                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                            degrees += 360
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .offset(y: -350)
                    }
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
