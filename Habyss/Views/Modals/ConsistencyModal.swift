import SwiftUI
import SwiftData
import Charts

struct ConsistencyModal: View {
    @Binding var isPresented: Bool
    @Query(filter: #Predicate<Habit> { !$0.isArchived }) var habits: [Habit]
    
    var overallConsistency: Double {
        // Mock avg calculation
        let consistencies = habits.map { calculateConsistency(for: $0) }
        guard !consistencies.isEmpty else { return 0 }
        return consistencies.reduce(0, +) / Double(consistencies.count)
    }
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Drag Handle
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 40, height: 4)
                    .padding(.top, 10)
                
                // Header
                HStack {
                    Button(action: { isPresented = false }) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "xmark").font(.caption).foregroundStyle(.white))
                    }
                    Spacer()
                    Text("CONSISTENCY")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {}) { // Share Placeholder
                        Circle()
                            .fill(Color.habyssGreen.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "square.and.arrow.up").font(.caption).foregroundStyle(Color.habyssGreen))
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Main Score Pie Chart
                        VoidCard(intensity: 30, cornerRadius: 24) {
                            VStack(spacing: 16) {
                                ZStack {
                                    // Placeholder Pie Chart (SwiftCharts support for Donut in iOS 17+)
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 12)
                                        .frame(width: 120, height: 120)
                                    Circle()
                                        .trim(from: 0, to: overallConsistency / 100)
                                        .stroke(Color.habyssGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                        .frame(width: 120, height: 120)
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack {
                                        Text("\(Int(overallConsistency))%")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundStyle(Color.habyssGreen)
                                        Text("Consistency")
                                            .font(.caption2)
                                            .foregroundStyle(Color.textSecondary)
                                    }
                                }
                                .padding(.top, 10)
                                
                                Text("Excellent Performance") // Dynamic based on score
                                    .font(.headline)
                                    .foregroundStyle(Color.habyssGreen)
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Per Habit Breakdown
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PER HABIT PERFORMANCE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1)
                                .foregroundStyle(Color.textSecondary)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(habits) { habit in
                                    let score = calculateConsistency(for: habit)
                                    VoidCard(intensity: 20, cornerRadius: 16) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: "star.fill") // Icon
                                                    .foregroundStyle(Color(hex: habit.color))
                                                Spacer()
                                                Text("\(Int(score))%")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(score >= 80 ? .green : .orange)
                                            }
                                            Text(habit.name)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.white)
                                                .lineLimit(1)
                                            
                                            // Mini Bar Chart Placeholder
                                            HStack(alignment: .bottom, spacing: 2) {
                                                ForEach(0..<7) { i in
                                                    // Fake bars
                                                    RoundedRectangle(cornerRadius: 1)
                                                        .fill(Color(hex: habit.color).opacity(i > 2 ? 1 : 0.3))
                                                        .frame(height: CGFloat.random(in: 4...20))
                                                }
                                            }
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func calculateConsistency(for habit: Habit) -> Double {
        // Mock logic: randomly high for demo
        return 85.0
    }
}
