//
//  SwiftUIView.swift
//  
//
//  Created by kimpepe on 2023/04/14.
//

import SwiftUI

struct ItemModalView: View {
    let item: Item
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Top half: Image (short animation image)
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            // Bottom half: Short explanation about it
            Text("description")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Bottom: Dismiss button
            Button("Dismiss", action: onDismiss)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
