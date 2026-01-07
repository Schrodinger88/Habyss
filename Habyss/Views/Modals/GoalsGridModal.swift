import SwiftUI
import SwiftData

struct GoalsGridModal: View {
    @Binding var isPresented: Bool
    @Query(filter: #Predicate<Habit> { !$0.isArchived }) var habits: [Habit]
    
    // In this model, Habits ARE goals effectively for now, unless we have separate Goal entities.
    // The previous Expo code had Goals vs Habits. Here we might just list Habits grouped?
    // Or if we implemented a Goal model, query that. Currently we only have Habit model.
    // Assuming Habits = Goals for MVP parity or strict adherence to existing SwiftData schema.
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { isPresented = false }) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "xmark").font(.caption).foregroundStyle(.white))
                    }
                    VStack(alignment: .leading) {
                        Text("MISSION CONTROL")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                        Text("GOALS OVERVIEW")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.habyssBlue)
                    }
                    Spacer()
                }
                .padding()
                .padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(habits) { habit in
                            VoidCard(intensity: 30, cornerRadius: 16) {
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: habit.color).opacity(0.2))
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "flag.fill") // Icon mock
                                            .foregroundStyle(Color(hex: habit.color))
                                    }
                                    
                                    Text(habit.name)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    // Progress Bar
                                    VStack(spacing: 4) {
                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                Capsule().fill(Color.white.opacity(0.1))
                                                Capsule().fill(Color(hex: habit.color))
                                                    .frame(width: geo.size.width * 0.45) // Mock 45%
                                            }
                                        }
                                        .frame(height: 4)
                                        
                                        Text("45%")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color(hex: habit.color))
                                    }
                                }
                                .padding(16)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
