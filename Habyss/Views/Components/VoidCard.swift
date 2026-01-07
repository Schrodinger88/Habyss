import SwiftUI

struct VoidCard<Content: View>: View {
    var content: Content
    var intensity: Double // Not directly used in SwiftUI Material but enables API compatibility thought process
    var cornerRadius: CGFloat
    
    init(intensity: Double = 80, cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.intensity = intensity
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack {
            // Glass Background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(0.9) // Adjust for "Void" darkness
                .colorScheme(.dark) // Force dark glass
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.black.opacity(0.2)) // Tint it darker
                )
            
            // Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            
            // Content
            content
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VoidCard {
            Text("Void Card")
                .foregroundStyle(.white)
        }
        .frame(width: 200, height: 100)
    }
}
