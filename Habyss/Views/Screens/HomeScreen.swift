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
    
    // Mock Stats for Demo (In real app, calculate from history)
    var averageGoalProgress: Double { 85.0 }
    var currentStreak: Int { 12 }
    var completionTier: Int { 3 }
    var consistencyScore: Int { 88 }
    
    func startTypewriter() {
        displayedQuote = ""
        for (index, char) in quoteText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                displayedQuote += String(char)
            }
        }
    }
    
    func isCompletedToday(_ habit: Habit) -> Bool {
        let calendar = Calendar.current
        return habit.completions.contains { calendar.isDateInToday($0.date) }
    }
    
    func toggleCompletion(for habit: Habit) {
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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                // Header
                HStack {
                    // Avatar (Parity with Expo: 44x44, clean border)
                    Button(action: {}) { // Link to Profile
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        // AI Sparkles (Gradient: Blue -> Purple -> Pink)
                        Button(action: { showAIModal = true }) {
                            Circle()
                                .fill(LinearGradient(colors: [.habyssBlue, .habyssPurple, .habyssPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 40)
                                .overlay(Image(systemName: "sparkles").font(.system(size: 18)).foregroundStyle(.white))
                        }
                        
                        // Notifications
                        Button(action: { showNotificationsModal = true }) {
                            Circle()
                                 .fill(Color.white.opacity(0.05))
                                 .frame(width: 40, height: 40)
                                 .overlay(Image(systemName: "bell.fill").font(.system(size: 20)).foregroundStyle(.white))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Motivational Quote (Typewriter Effect)
                        VStack(alignment: .leading) {
                            Text(displayedQuote + (displayedQuote.count < quoteText.count ? "|" : ""))
                                .font(.system(size: 14, weight: .bold, design: .rounded)) // Lexend 700
                                .foregroundStyle(Color.textSecondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .onAppear {
                                    startTypewriter()
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Goals Progress (Linear Bar - Parity)
                        Button {
                            showGoalsModal = true
                        } label: {
                            VoidCard(intensity: 80.0) {
                                VStack(spacing: 16) {
                                    HStack {
                                        HStack(spacing: 10) {
                                            Image(systemName: "flag.fill").foregroundStyle(Color.habyssPurple)
                                            Text("GOALS PROGRESS")
                                                .font(.system(size: 14, weight: .black))
                                                .tracking(1.5)
                                                .foregroundStyle(.white)
                                        }
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Text("\(goals.count)")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundStyle(Color.white.opacity(0.6))
                                            Image(systemName: "chevron.forward")
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color.white.opacity(0.4))
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                    
                                    HStack(spacing: 16) {
                                        // Linear Bar
                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                Capsule()
                                                    .fill(Color.white.opacity(0.08))
                                                
                                                Capsule()
                                                    .fill(LinearGradient(colors: [.habyssBlue, .habyssPurple], startPoint: .leading, endPoint: .trailing))
                                                    .frame(width: geo.size.width * CGFloat(averageGoalProgress) / 100)
                                            }
                                        }
                                        .frame(height: 6)
                                        
                                        Text("\(Int(averageGoalProgress))%")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundStyle(.white)
                                            .frame(width: 60, alignment: .trailing)
                                    }
                                    
                                    Text("TRACK YOUR ACTIVE MISSIONS")
                                        .font(.system(size: 10))
                                        .tracking(1)
                                        .foregroundStyle(Color.white.opacity(0.4))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Streak & Consistency (Bento Row)
                        HStack(spacing: 12) {
                             Button(action: { showStreakModal = true }) {
                                 StreakCard(streak: currentStreak, completionTier: completionTier)
                             }
                             
                             Button(action: { showConsistencyModal = true }) {
                                 ConsistencyCard(score: consistencyScore)
                             }
                        }
                        .padding(.horizontal)
                        
                        // Analytics Dashboard (Radar Chart)
                        AnalyticsDashboard(habits: habits, completions: habits.reduce(into: [:]) { dict, habit in
                            dict[habit.id] = isCompletedToday(habit)
                        })
                        .padding(.horizontal)

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
        VoidCard(intensity: 60.0, cornerRadius: 16) {
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
