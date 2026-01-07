import SwiftUI
import SwiftData
import Charts

struct GoalDetailScreen: View {
    @Bindable var goal: Habit // The Goal itself (isGoal = true)
    @Query private var allHabits: [Habit]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedSegment = "Stats"
    let segments = ["Habits", "Stats"]
    
    // Filter habits belonging to this goal
    var linkedHabits: [Habit] {
        allHabits.filter { $0.goalId == goal.id }
    }
    
    // Calculations
    var totalTasks: Int {
        // Mocking total tasks count based on duration or just simplistic count
        // For visual parity with "27 Remaining", we might need more complex logic
        // For now: Assumes 30 days * linked habits count
        return linkedHabits.count * 30 
    }
    
    var completedTasks: Int {
        linkedHabits.reduce(0) { $0 + $1.completions.count }
    }
    
    var remainingTasks: Int {
        max(0, totalTasks - completedTasks)
    }
    
    var progress: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var daysLeft: Int {
        guard let target = goal.targetDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
    }
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (Navigation + Title)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    // Edit/Delete actions placeholder (Screenshot shows pencil/trash)
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Circle().fill(Color.white.opacity(0.1)).frame(width: 36, height: 36)
                                .overlay(Image(systemName: "pencil").font(.system(size: 14)).foregroundStyle(.white))
                        }
                        Button(action: {}) {
                            Circle().fill(Color.red.opacity(0.2)).frame(width: 36, height: 36)
                                .overlay(Image(systemName: "trash").font(.system(size: 14)).foregroundStyle(.red))
                        }
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goal.name)
                                .font(.system(size: 32, weight: .bold)) // Lexend
                                .foregroundStyle(.white)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(Color.textTertiary)
                                Text("Target: \(goal.targetDate?.formatted(date: .numeric, time: .omitted) ?? "None")")
                                    .foregroundStyle(Color.textTertiary)
                                
                                if daysLeft > 0 {
                                    Text("\(daysLeft) days left")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.habyssPurple)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.habyssPurple.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                            .font(.system(size: 14))
                        }
                        .padding(.horizontal)
                        
                        // Segmented Control
                        HStack(spacing: 0) {
                            ForEach(segments, id: \.self) { segment in
                                Button(action: { selectedSegment = segment }) {
                                    VStack(spacing: 8) {
                                        Text(segment)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(selectedSegment == segment ? .white : Color.textTertiary)
                                        
                                        Rectangle()
                                            .fill(selectedSegment == segment ? Color.white : Color.clear)
                                            .frame(height: 2)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        if selectedSegment == "Stats" {
                            StatsView
                        } else {
                            HabitsListView
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    
    var StatsView: some View {
        VStack(spacing: 20) {
            Text("MISSION ANALYTICS")
                .font(.caption)
                .tracking(2)
                .foregroundStyle(Color.textTertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                // Circular Progress
                VoidCard(intensity: 40, cornerRadius: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 12)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.habyssPurple, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                            Text("COMPLETED")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                    .padding(24)
                }
                .frame(height: 180)
                
                // Stats Grid
                VStack(spacing: 16) {
                    VoidCard(intensity: 40, cornerRadius: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(completedTasks)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.habyssGreen)
                            Text("HABITS COMPLETED")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VoidCard(intensity: 40, cornerRadius: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(remainingTasks)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.habyssRed)
                            Text("HABITS REMAINING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 180)
            }
            .padding(.horizontal)
            
            // Trajectory
            VStack(spacing: 12) {
                HStack {
                    Text("ACTIVITY TRAJECTORY")
                        .font(.caption)
                        .tracking(2)
                        .foregroundStyle(Color.textTertiary)
                    Spacer()
                    Text("Touch to inspect")
                        .font(.caption2)
                        .foregroundStyle(Color.textTertiary)
                }
                
                VoidCard(intensity: 30, cornerRadius: 16) {
                    Chart(linkedHabits) { habit in
                        // Mocking activity data over time based on completion dates
                        ForEach(habit.completions) { completion in
                            LineMark(
                                x: .value("Date", completion.date),
                                y: .value("Count", 1) // Simplified accumulation
                            )
                            .foregroundStyle(Color.habyssPurple)
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(
                                x: .value("Date", completion.date),
                                y: .value("Count", 1)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.habyssPurple.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .frame(height: 150)
                    .padding()
                }
            }
            .padding(.horizontal)
        }
    }
    
    var HabitsListView: some View {
        VStack(spacing: 16) {
            if linkedHabits.isEmpty {
                ContentUnavailableView("No Linked Habits", systemImage: "link", description: Text("Add habits to this goal to track progress."))
            } else {
                ForEach(linkedHabits) { habit in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(Color(hex: habit.color))
                        Text(habit.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.textTertiary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}
