import SwiftUI
import SwiftData
import Charts

struct HabitDetailScreen: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showEditSheet = false
    
    // Derived Stats
    var currentStreak: Int {
        // Simple logic for now, similar to Manager
        // TODO: Move to centralized HabitManager logic
        return calculateStreak(for: habit)
    }
    
    var completionRate: Int {
        let total = 30 // Last 30 days
        let completed = habit.completions.filter {
            $0.date > Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        }.count
        return Int((Double(completed) / Double(total)) * 100)
    }
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Main Info Card
                    VoidCard(intensity: 60, cornerRadius: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: habit.color).opacity(0.2))
                                    .frame(width: 80, height: 80)
                                Image(systemName: "star.fill") // TODO: Icon mapping
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color(hex: habit.color))
                            }
                            
                            VStack(spacing: 4) {
                                Text(habit.name)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text("\(habit.category) • DAILY")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .tracking(1)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            
                            Button(action: toggleCompletion) {
                                HStack {
                                    Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                                    Text(isCompletedToday ? "PROTOCOL COMPLETE" : "EXECUTE PROTOCOL")
                                }
                                .fontWeight(.bold)
                                .font(.callout)
                                .padding(.horizontal, 24)
                                .paddingVertical(12)
                                .background(isCompletedToday ? Color.habyssGreen : Color.habyssBlue)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Visualization (Charts)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("VISUALIZATION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1)
                            .foregroundStyle(Color.textSecondary)
                        
                        VoidCard(intensity: 40, cornerRadius: 16) {
                            Chart {
                                ForEach(last30DaysHistory, id: \.date) { data in
                                    BarMark(
                                        x: .value("Date", data.date, unit: .day),
                                        y: .value("Completed", data.completed ? 1 : 0)
                                    )
                                    .foregroundStyle(data.completed ? Color(hex: habit.color) : Color.white.opacity(0.1))
                                    .cornerRadius(4)
                                }
                            }
                            .chartYAxis(.hidden)
                            .chartXAxis(.hidden)
                            .frame(height: 150)
                            .padding(16)
                        }
                    }
                    
                    // Stats Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PERFORMANCE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1)
                            .foregroundStyle(Color.textSecondary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(title: "STREAK", value: "\(currentStreak) DAYS", icon: "flame.fill", color: .orange)
                            StatCard(title: "RATE", value: "\(completionRate)%", icon: "chart.line.uptrend.xyaxis", color: .green)
                            StatCard(title: "TOTAL", value: "\(habit.completions.count)", icon: "checkmark.circle.fill", color: .blue)
                            StatCard(title: "BEST", value: "\(currentStreak)", icon: "trophy.fill", color: .yellow) // TODO: Calculate Best
                        }
                    }
                    
                    // Directive
                    VoidCard(intensity: 30, cornerRadius: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DIRECTIVE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textSecondary)
                            Text(habit.details ?? "Consistency is key. Maintain your streak to achieve optimal results.")
                                .font(.body)
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                .padding(20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEditSheet = true }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            // Re-use HabitCreationView for editing? Or make a specific Edit view.
            Text("Edit Habit Placeholder")
                .presentationDetents([.medium])
        }
    }
    
    // Helpers
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return habit.completions.contains { calendar.isDateInToday($0.date) }
    }
    
    func toggleCompletion() {
        let today = Date()
        let calendar = Calendar.current
        
        if let existing = habit.completions.first(where: { calendar.isDateInToday($0.date) }) {
            habit.completions.removeAll { $0.id == existing.id }
            modelContext.delete(existing)
        } else {
            let completion = Completion(date: today)
            habit.completions.append(completion)
        }
    }
    
    var last30DaysHistory: [(date: Date, completed: Bool)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var history: [(Date, Bool)] = []
        
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let isDone = habit.completions.contains { calendar.isDate($0.date, inSameDayAs: date) }
                history.append((date, isDone))
            }
        }
        return history.reversed()
    }
    
    func calculateStreak(for habit: Habit) -> Int {
        // Reuse logic from HabitManager or duplicate for now
        // This is a simplified "current streak" view
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Simple consecutive check backwards
        // (This is NOT robust for gaps/schedule, but MVP for UI)
        // ... (Proper logic is complex, sticking to simple count for UI)
        return streak // TODO: Connect to Manager
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VoidCard(intensity: 40, cornerRadius: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: icon)
                            .foregroundStyle(color)
                            .font(.caption)
                        Text(title)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                Spacer()
            }
            .padding(16)
        }
    }
}
