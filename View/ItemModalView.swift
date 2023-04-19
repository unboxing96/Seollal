
import SwiftUI

struct ItemModalView: View {
    let item: Item
    let image: UIImage
    let onDismiss: () -> Void

    
    var body: some View {
        VStack(spacing: 20) {
            Text(item.itemName)
                .font(.largeTitle)
                .fontWeight(.black)
                .frame(height: 100)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 400)
            
            Text(item.itemDescription)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 200)
                .multilineTextAlignment(.leading) // Align text to the leading edge (left for left-to-right languages)
            
            Button("Dismiss", action: onDismiss)
                .padding()
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
                .frame(height: 100)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 750, height: 1000)
    }
}
