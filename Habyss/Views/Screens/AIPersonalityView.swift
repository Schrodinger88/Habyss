import SwiftUI

struct AIPersonalityView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Mock State
    @State private var selectedPersonality: String = "Friendly"
    
    let personalities = [
        Personality(
            id: "Friendly",
            emoji: "😊",
            description: "Your supportive best friend who celebrates every win and provides gentle encouragement.",
            color: Color(hex: "4ECDC4"), // Teal
            traits: [0.9, 0.4, 0.7, 0.2, 0.9] // Warmth, Directness, Humor, Toughness, Empathy
        ),
        Personality(
            id: "Normal",
            emoji: "🙂",
            description: "Balanced and encouraging with data-driven insights and realistic feedback.",
            color: Color.habyssBlue,
            traits: [0.6, 0.7, 0.4, 0.4, 0.7]
        ),
        Personality(
            id: "Dad Mode",
            emoji: "👨",
            description: "Firm but caring guidance that holds you accountable and expects your best effort.",
            color: Color.habyssBlue, // Or maybe slightly darker blue? Screenshot uses generic text color for title?
            traits: [0.5, 0.8, 0.3, 0.7, 0.4]
        )
    ]
    
    let traitLabels = ["Warmth", "Directness", "Humor", "Toughness", "Empathy"]
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color.textPrimary)
                    }
                    Spacer()
                    Text("AI Personality")
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding()
                .background(Color.habyssBlack)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(personalities, id: \.id) { personality in
                            Button(action: { selectedPersonality = personality.id }) {
                                PersonalityCard(
                                    personality: personality,
                                    isSelected: selectedPersonality == personality.id,
                                    traitLabels: traitLabels
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct Personality {
    let id: String
    let emoji: String
    let description: String
    let color: Color
    let traits: [Double]
}

struct PersonalityCard: View {
    let personality: Personality
    let isSelected: Bool
    let traitLabels: [String]
    
    var body: some View {
        VoidCard(intensity: isSelected ? 40 : 20, cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack(alignment: .top, spacing: 12) {
                    Text(personality.emoji)
                        .font(.custom("System", size: 32)) // Large emoji
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(personality.id)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.textPrimary)
                        
                        Text(personality.description)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(personality.color)
                    }
                }
                
                // Traits
                VStack(spacing: 8) {
                    ForEach(0..<traitLabels.count, id: \.self) { i in
                        HStack {
                            Text(traitLabels[i])
                                .font(.caption2)
                                .foregroundStyle(Color.textTertiary)
                                .frame(width: 60, alignment: .leading)
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 4)
                                    
                                    Capsule()
                                        .fill(personality.color)
                                        .frame(width: geo.size.width * CGFloat(personality.traits[i]), height: 4)
                                }
                            }
                            .frame(height: 4)
                        }
                    }
                }
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? personality.color : Color.clear, lineWidth: 2)
        )
    }
}
