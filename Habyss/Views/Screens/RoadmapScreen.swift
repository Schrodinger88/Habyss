import SwiftUI
import SwiftData

struct RoadmapScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.name) private var allHabits: [Habit]
    
    @State private var selectedDate: Date = Date()
    
    // Calendar Generation
    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let week = (-3...3).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
        return week
    }
    var goals: [Habit] {
        allHabits.filter { $0.isGoal }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header / Calendar Strip
                    VStack(spacing: 20) {
                        Text(selectedDate.formatted(date: .complete, time: .omitted))
                            .font(.headline)
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(currentWeek, id: \.self) { date in
                                    CalendarDayButton(
                                        date: date,
                                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                        onSelect: { selectedDate = date }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                    .background(
                        LinearGradient(
                            colors: [.habyssDarkBlue, .habyssBlack],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Content: Goals List
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("GOALS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(2)
                                .foregroundStyle(Color.textTertiary)
                            
                            if goals.isEmpty {
                                ContentUnavailableView(
                                    "No Active Goals",
                                    systemImage: "flag.slash",
                                    description: Text("Create a goal to start tracking your missions.")
                                )
                                .foregroundStyle(Color.textSecondary)
                                .padding(.top, 40)
                            } else {
                                ForEach(goals) { goal in
                                    NavigationLink(destination: GoalDetailScreen(goal: goal)) {
                                        RoadmapGoalCard(goal: goal)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Subviews

struct RoadmapGoalCard: View {
    var goal: Habit
    
    // Derived Stats (Mock/Simple)
    var daysLeft: Int {
        guard let target = goal.targetDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
    }
    
    var progress: Double {
        // Mock progress for parity demo
        return 0.1 // 10% as per screenshot
    }
    
    var body: some View {
        VoidCard(intensity: 30.0, cornerRadius: 16) {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Icon Box
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: goal.color).opacity(0.15))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "flag.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(hex: goal.color))
                        
                        // External Link Icon (small)
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 8))
                            .foregroundStyle(Color.textTertiary)
                            .offset(x: 14, y: 14)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goal.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        // Progress Bar Row
                        HStack(spacing: 12) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                    
                                    Capsule()
                                        .fill(Color.habyssPurple)
                                        .frame(width: geo.size.width * progress)
                                }
                            }
                            .frame(height: 6)
                            
                            if daysLeft > 0 {
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(daysLeft)d")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(4)
                                        .foregroundStyle(Color.textSecondary)
                                    
                                    Text("\(Int(progress * 100))%")
                                        .font(.caption2)
                                        .fontWeight(.bold) // Lexend
                                        .foregroundStyle(Color.habyssPurple)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Chevron / Expand
                    VStack {
                         Spacer()
                         Image(systemName: "chevron.right") // Or down if expandable
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.textTertiary)
                         Spacer()
                    }
                }
            }
            .padding(16)
        }
    }
}

struct CalendarDayButton: View {
    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 6) {
                Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(isSelected ? .white : Color.textTertiary)
                
                Text(date.formatted(.dateTime.day()))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(isSelected ? .white : Color.textSecondary)
                
                if isSelected {
                    Circle()
                        .fill(Color.habyssPurple)
                        .frame(width: 4, height: 4)
                } else {
                    Color.clear.frame(width: 4, height: 4)
                }
            }
            .frame(width: 50, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.habyssPurple.opacity(0.2) : Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.habyssPurple.opacity(0.5) : Color.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
}
