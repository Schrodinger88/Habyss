import SwiftUI

struct StreakCard: View {
    var streak: Int
    var completionTier: Int = 0

    
    var body: some View {
        VoidCard(intensity: 80, cornerRadius: 24) {
            VStack(spacing: 8) {
                // Icon / Flame
                ZStack {
                    Circle()
                        .fill(Color.habyssCoral.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "flame.fill")
                        .foregroundStyle(Color.habyssCoral)
                        .font(.system(size: 20))
                }
                
                VStack(spacing: 2) {
                    Text("\(streak)")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("DAY STREAK")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
