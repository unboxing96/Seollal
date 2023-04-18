
import SwiftUI

struct ItemModalView: View {
    let item: Item
    let image: UIImage
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(item.itemName)
                .font(.title)
                .padding()
                .frame(height: 100)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 400)
            
            Text(item.itemDescription)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 200)
            
            Button("Dismiss", action: onDismiss)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(height: 100)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 600, height: 900)
    }
}
