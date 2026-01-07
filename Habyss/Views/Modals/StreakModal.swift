import SwiftUI
import SwiftData

struct StreakModal: View {
    @Binding var isPresented: Bool
    @Query(filter: #Predicate<Habit> { !$0.isArchived }) var habits: [Habit]
    @State private var selectedHabitId: UUID?
    
    var currentStreak: Int = 12 // Mock
    
    var heatmapData: [(Date, Bool)] {
        // Generate last 365 days
        let calendar = Calendar.current
        let today = Date()
        var days: [(Date, Bool)] = []
        for i in 0..<120 { // Last 4 months roughly
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                // Mock: random completion
                days.append((date, Bool.random())) 
            }
        }
        return days.reversed()
    }
    
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
                    Spacer()
                    Text("STREAK")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {}) {
                        Circle()
                            .fill(Color.habyssCoral.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "square.and.arrow.up").font(.caption).foregroundStyle(Color.habyssCoral))
                    }
                }
                .padding()
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Main Streak Card
                        VoidCard(intensity: 30, cornerRadius: 24) {
                            VStack(spacing: 8) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color.habyssCoral)
                                Text("\(currentStreak)")
                                    .font(.system(size: 56, weight: .black, design: .rounded))
                                    .foregroundStyle(Color.white)
                                Text("DAY STREAK")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .tracking(2)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .padding(32)
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Habit Selector Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(habits) { habit in
                                    Button(action: { selectedHabitId = habit.id }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "star.fill") // Icon map
                                            Text(habit.name)
                                        }
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedHabitId == habit.id ? Color(hex: habit.color) : Color.white.opacity(0.05))
                                        .foregroundStyle(selectedHabitId == habit.id ? .white : Color.textSecondary)
                                        .cornerRadius(20)
                                        .overlay(
                                            Capsule().stroke(Color(hex: habit.color), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Heatmap
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ACTIVITY LOG")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            VoidCard(intensity: 20, cornerRadius: 16) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                                    ForEach(heatmapData, id: \.0) { item in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(item.1 ? Color.habyssCoral : Color.white.opacity(0.05))
                                            .aspectRatio(1, contentMode: .fit)
                                    }
                                }
                                .padding(12)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
