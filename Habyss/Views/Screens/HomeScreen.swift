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
    
    var todaysHabits: [Habit] {
        habits.filter { habit in
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            // Check if the habit is scheduled for today
            let isScheduledToday = habit.schedule.contains { day in
                let weekday = calendar.component(.weekday, from: today)
                return day.rawValue == weekday
            }
            
            // If the habit is scheduled for today, include it
            return isScheduledToday
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header: Profile & Notifications
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.textSecondary)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button(action: { showAIModal = true }) {
                                    Circle()
                                        .fill(LinearGradient(colors: [.habyssBlue, .habyssPurple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 40, height: 40)
                                        .overlay(Image(systemName: "sparkles").foregroundStyle(.white))
                                }
                                
                                Button(action: { showNotificationsModal = true }) {
                                    Circle()
                                        .fill(Color.white.opacity(0.05))
                                        .frame(width: 40, height: 40)
                                        .overlay(Image(systemName: "bell.fill").foregroundStyle(.white))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Motivational Quote (Typewriter Style)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Consistency beats intensity.")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                            Text("You've got this.")
                                .font(.caption)
                                .foregroundStyle(Color.habyssBlue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Goals Progress Bar Summary
                        Button(action: { showGoalsModal = true }) {
                            VoidCard(intensity: 40, cornerRadius: 16) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Mission Status")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.textSecondary)
                                        Text("85% On Track")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.white)
                                    }
                                    Spacer()
                                    CircularProgress(progress: 0.85, size: 40, color: .habyssBlue)
                                }
                                .padding(12)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)

                        // Bento Grid Stats
                        HStack(spacing: 12) {
                            Button(action: { showStreakModal = true }) {
                                StreakCard(streak: 12, completionTier: 3)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { showConsistencyModal = true }) {
                                ConsistencyCard(score: 88)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                        
                        // Today's Habits
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("TODAY'S HABITS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.textSecondary)
                                    .tracking(1)
                                
                                Spacer()
                                
                                NavigationLink(destination: RoadmapScreen()) { // Link to Calendar
                                    Text("See All")
                                        .font(.caption)
                                        .foregroundStyle(Color.textTertiary)
                                }
                            }
                            .padding(.horizontal)
                            
                            if todaysHabits.isEmpty {
                                ContentUnavailableView("No Mission", systemImage: "moon.stars.fill", description: Text("Rest day."))
                                    .foregroundStyle(Color.textSecondary)
                            } else {
                                ForEach(todaysHabits) { habit in
                                    NavigationLink(destination: HabitDetailScreen(habit: habit)) {
                                        HabitRow(habit: habit)
                                    }
                                    .buttonStyle(.plain)
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

struct CircularProgress: View {
    let progress: Double
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
}
