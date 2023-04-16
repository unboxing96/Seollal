//
//  SwiftUIView.swift
//  
//
//  Created by kimpepe on 2023/04/15.
//

import SwiftUI

struct GameEndView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Top-half with animated image
            Image("animationImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .infinity)

            // Bottom-half with text introduction and dismiss button
            VStack {
                Text("Congratulations! You've collected all the items.")
                    .font(.title)
                    .padding()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dismiss")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct GameEndView_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView()
    }
}
