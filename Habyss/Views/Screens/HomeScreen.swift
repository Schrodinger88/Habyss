import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Query(filter: #Predicate<Habit> { !$0.isArchived }) var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showGoalsModal = false
    @State private var showStreakModal = false
    @State private var showConsistencyModal = false
    @State private var showAIModal = false
    @State private var showNotificationsModal = false
    
    // UI State for Parity
    @State private var displayedQuote = ""
    private let quoteText = "Consistency beats intensity."
    
    var goals: [Habit] {
        habits.filter { $0.isGoal }
    }
    
    var todaysHabits: [Habit] {
        habits.filter { habit in
            guard !habit.isGoal else { return false } // Exclude Goals
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let isScheduledToday = habit.taskDays.contains { day in // Fixed property name 'taskDays'
                let weekday = calendar.component(.weekday, from: today)
                let symbol = calendar.shortWeekdaySymbols[weekday - 1].lowercased()
                return day == symbol
            }
            return isScheduledToday
        }
    }
    
    // ... (rest of body) ...

                        // Habits List ("Quick Habits")
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Today's Habits")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Spacer()
                                NavigationLink(destination: RoadmapScreen()) {
                                    Text("See All")
                                        .font(.caption)
                                        .foregroundStyle(Color.white.opacity(0.5))
                                }
                            }
                            
                            if todaysHabits.isEmpty {
                                ContentUnavailableView("All Clear", systemImage: "checkmark.circle", description: Text("No habits scheduled for today."))
                            } else {
                                ForEach(todaysHabits) { habit in
                                    NavigationLink(destination: HabitDetailScreen(habit: habit)) {
                                        HabitRow(habit: habit, goalName: goals.first(where: { $0.id == habit.goalId })?.name)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
             .sheet(isPresented: $showGoalsModal) { GoalsGridModal(isPresented: $showGoalsModal) }
            .sheet(isPresented: $showStreakModal) { StreakModal(isPresented: $showStreakModal) }
            .sheet(isPresented: $showConsistencyModal) { ConsistencyModal(isPresented: $showConsistencyModal) }
            .fullScreenCover(isPresented: $showAIModal) { AIAgentView(isPresented: $showAIModal) }
            .sheet(isPresented: $showNotificationsModal) { NotificationsView(isPresented: $showNotificationsModal) }
        }
    }
}

// Simple Habit Row for the list
struct HabitRow: View {
    var habit: Habit
    var goalName: String?
    @Environment(\.modelContext) private var modelContext
    
    var isCompleted: Bool {
        let calendar = Calendar.current
        return habit.completions.contains { calendar.isDateInToday($0.date) }
    }
    
    var body: some View {
        VoidCard(intensity: 60, cornerRadius: 16) {
            HStack(spacing: 16) {
                // Icon / Left Checkmark
                ZStack {
                    if isCompleted {
                        Circle()
                            .fill(Color(hex: habit.color).opacity(0.2))
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color(hex: habit.color))
                    } else {
                        Circle()
                            .fill(Color(hex: habit.color).opacity(0.1))
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: habit.color).opacity(0.5))
                    }
                }
                .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isCompleted ? Color.textSecondary : Color.textPrimary)
                    
                    if let goal = goalName {
                         Text(goal.capitalized)
                            .font(.caption)
                            .foregroundStyle(Color.textTertiary)
                    } else {
                        Text(habit.category.capitalized)
                            .font(.caption)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                
                Spacer()
                
                // Right Checkbox (Toggle)
                Button {
                    toggleCompletion()
                } label: {
                    ZStack {
                         if isCompleted {
                            Circle()
                                .fill(Color(hex: habit.color))
                                .frame(width: 32, height: 32)
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                        } else {
                            Circle()
                                .stroke(Color(hex: habit.color).opacity(0.5), lineWidth: 2)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
            }
            .padding(16)
        }
        .frame(height: 80)
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
}

#Preview {
    HomeScreen()
        .modelContainer(for: [Habit.self, Completion.self, Profile.self], inMemory: true)
}
