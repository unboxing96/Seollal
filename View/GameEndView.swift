//
//  SwiftUIView.swift
//  
//
//  Created by kimpepe on 2023/04/15.
//

import SwiftUI

struct GameEndView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isHomeActive = false
    @State private var rotationAngle: Double = 0.0 // 회전 각도를 저장할 State 변수
    let numberOfImages: Int = 5 // 이미지의 개수
    let radius: CGFloat = 150.0 // 원형으로 배치할 반지름

    // 이미지 이름을 배열로 선언
    let imageNames = ["player", "player", "player", "player", "player"]

    var body: some View {
        Group {
            if !isHomeActive {
                ZStack {
                    Image("start_night")
                    Image("start_moon")
                        .scaleEffect(0.4)
                    
                    ZStack {
                        ForEach(0..<numberOfImages, id: \.self) { index in
                            Image(imageNames[index]) // 이미지 배열에서 이미지 이름을 로드
                                .resizable()
                                .frame(width: 70, height: 70)
                                .rotationEffect(Angle(degrees: -rotationAngle)) // 각 이미지는 반대로 회전하여 이전 각도를 유지
                                .offset(x: radius * 2 * CGFloat(cos(Double(index) * 2 * .pi / Double(numberOfImages))),
                                        y: radius * 2 * CGFloat(sin(Double(index) * 2 * .pi / Double(numberOfImages))))
                        }
                    }
                    .rotationEffect(Angle(degrees: rotationAngle)) // 전체 ZStack을 회전하여 원형으로 배치된 이미지들을 함께 회전
                    
                    Image("end_title1")
                        .scaleEffect(0.9)
                        .offset(y: -520)
                }
                .frame(maxHeight: .infinity)
                .onAppear {
                    withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
            } else {
                ContentView()
            }
        }
    }
}

struct GameEndView_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView()
    }
}

//
//import SwiftUI
//
//struct RotatingImagesView: View {
//    @State private var rotationAngle: Double = 0.0 // 회전 각도를 저장할 State 변수
//    let numberOfImages: Int = 5 // 이미지의 개수
//    let radius: CGFloat = 150.0 // 원형으로 배치할 반지름
//
//    // 이미지 이름을 배열로 선언
//    let imageNames = ["image1", "image2", "image3", "image4", "image5"]
//
//    var body: some View {
//        VStack {
//            Spacer()
//            ZStack {
//                ForEach(0..<numberOfImages, id: \.self) { index in
//                    Image(imageNames[index]) // 이미지 배열에서 이미지 이름을 로드
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .rotationEffect(Angle(degrees: -rotationAngle)) // 각 이미지는 반대로 회전하여 이전 각도를 유지
//                        .offset(x: radius * CGFloat(cos(Double(index) * 2 * .pi / Double(numberOfImages))),
//                                y: radius * CGFloat(sin(Double(index) * 2 * .pi / Double(numberOfImages))))
//                }
//            }
//            .rotationEffect(Angle(degrees: rotationAngle)) // 전체 ZStack을 회전하여 원형으로 배치된 이미지들을 함께 회전
//            Spacer()
//        }
//        .onAppear {
//            withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
//                rotationAngle = 360.0 // 애니메이션을 통해 회전 각도를 360도로 설정하여 전체가 한 방향으로 회전
//            }
//        }
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        RotatingImagesView()
//    }
//}
