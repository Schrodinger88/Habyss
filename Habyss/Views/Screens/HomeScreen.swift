import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Query(filter: #Predicate<Habit> { !$0.isArchived }) var habits: [Habit]
    
    var body: some View {
        ZStack {
            // Background
            Color.habyssBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundStyle(Color.textSecondary)
                            Text("Traveler") // TODO: Profile Name
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textPrimary)
                        }
                        Spacer()
                        
                        // Avatar
                        Circle()
                            .fill(Color.habyssNavy)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.habyssBlue)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Bento Grid (Stats)
                    HStack(spacing: 12) {
                        StreakCard(streak: 3) // TODO: Calculate Real Streak
                            .frame(height: 140)
                        
                        ConsistencyCard(score: 85) // TODO: Calculate Real Consistency
                            .frame(height: 140)
                    }
                    .padding(.horizontal)
                    
                    // Today's Habits
                    VStack(alignment: .leading, spacing: 16) {
                        Text("TODAY'S MISSION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1)
                            .foregroundStyle(Color.textSecondary)
                            .padding(.horizontal)
                        
                        if habits.isEmpty {
                            ContentUnavailableView(
                                "No Habits Yet",
                                systemImage: "sparkles",
                                description: Text("Tap the + button to create your first habit.")
                            )
                            .foregroundStyle(Color.textSecondary)
                            .padding(.top, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(habits) { habit in
                                    HabitRow(habit: habit)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

// Simple Habit Row for the list
struct HabitRow: View {
    var habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    var isCompleted: Bool {
        // Simple check (in real app use Manager logic)
        // For MVP UI demo just checking if completions has today
        let calendar = Calendar.current
        return habit.completions.contains { calendar.isDateInToday($0.date) }
    }
    
    var body: some View {
        VoidCard(intensity: 60, cornerRadius: 16) {
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: habit.color).opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "star.fill") // TODO: Habit Icon mapping
                        .foregroundStyle(Color(hex: habit.color))
                }
                
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                        .strikethrough(isCompleted)
                        .opacity(isCompleted ? 0.6 : 1)
                    
                    if let details = habit.details {
                        Text(details)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Checkbox
                Button {
                    toggleCompletion()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isCompleted ? Color(hex: habit.color) : Color.white.opacity(0.2), lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isCompleted ? Color(hex: habit.color) : Color.clear)
                            )
                            .frame(width: 28, height: 28)
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .frame(height: 70)
    }
    
    func toggleCompletion() {
        // Quick inline logic for UI demo - should move to Manager
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
