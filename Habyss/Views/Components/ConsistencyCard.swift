import SwiftUI
import Charts

struct ConsistencyCard: View {
    var score: Double // 0-100
    
    var color: Color {
        if score >= 80 { return .habyssTeal }
        if score >= 60 { return .yellow }
        return .habyssCoral
    }
    
    var body: some View {
        VoidCard(intensity: 80, cornerRadius: 24) {
            VStack(spacing: 8) {
                // Ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: score / 100)
                        .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: "waveform.path.ecg")
                        .foregroundStyle(color)
                        .font(.system(size: 14))
                }
                
                VStack(spacing: 2) {
                    Text("\(Int(score))%")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundStyle(color)
                    
                    Text("CONSISTENCY")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
