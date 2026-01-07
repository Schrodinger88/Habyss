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
    
    var body: some View {
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
                        .padding(.top, 60)
                    
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
                
                // Content (Timeline / Habits for Date)
                ScrollView {
                    VStack(spacing: 24) {
                        let todaysHabits = allHabits.filter { habit in
                            // Filter logic: Check if habit is scheduled for this weekday
                            let weekday = Calendar.current.component(.weekday, from: selectedDate)
                            // Rough mapping for demo: 1=Sun, 2=Mon...
                            // Assuming habit.taskDays uses "mon", "tue" etc.
                            let dayName = Calendar.current.shortWeekdaySymbols[weekday - 1].lowercased()
                            return habit.taskDays.contains(dayName)
                        }
                        
                        if todaysHabits.isEmpty {
                            ContentUnavailableView(
                                "No Mission",
                                systemImage: "moon.stars.fill",
                                description: Text("No habits scheduled for this day.")
                            )
                            .foregroundStyle(Color.textSecondary)
                            .padding(.top, 60)
                        } else {
                            ForEach(todaysHabits) { habit in
                                HabitTimelineRow(habit: habit, date: selectedDate)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct CalendarDayButton: View {
    var date: Date
    var isSelected: Bool
    var onSelect: () -> Void
    
    var isToday: Bool { Calendar.current.isDateInToday(date) }
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Text(date.formatted(.dateTime.weekday(.abbreviated)).prefix(1))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? .white : Color.textTertiary)
                
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.habyssBlue)
                            .frame(width: 36, height: 36)
                            .shadow(color: .habyssBlue.opacity(0.5), radius: 8)
                    } else if isToday {
                        Circle()
                            .stroke(Color.habyssBlue, lineWidth: 1)
                            .frame(width: 36, height: 36)
                    }
                    
                    Text(date.formatted(.dateTime.day()))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? .white : Color.textPrimary)
                }
                
                // Dot indicator if has completions (Mocked)
                Circle()
                    .fill(isSelected ? .white : Color.clear)
                    .frame(width: 4, height: 4)
                    .opacity(0.8)
            }
            .frame(width: 50)
        }
    }
}

struct HabitTimelineRow: View {
    var habit: Habit
    var date: Date
    @Environment(\.modelContext) private var modelContext
    
    var isCompleted: Bool {
        let calendar = Calendar.current
        return habit.completions.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline Line
            VStack {
                Circle()
                    .fill(isCompleted ? Color(hex: habit.color) : Color.habyssNavy) // TODO: Use habit color
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: habit.color).opacity(0.5), lineWidth: isCompleted ? 0 : 2)
                    )
                
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 24)
            
            // Card
            VoidCard(intensity: 60, cornerRadius: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.headline)
                            .foregroundStyle(isCompleted ? Color.textSecondary : Color.textPrimary)
                            .strikethrough(isCompleted)
                        
                        Text(habit.category.capitalized)
                            .font(.caption)
                            .foregroundStyle(Color.textTertiary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Button {
                        toggleCompletion()
                    } label: {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 28))
                            .foregroundStyle(isCompleted ? Color(hex: habit.color) : Color.textTertiary)
                    }
                }
            }
        }
        .frame(height: 80)
    }
    
    func toggleCompletion() {
        let calendar = Calendar.current
        if let existing = habit.completions.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            habit.completions.removeAll { $0.id == existing.id }
            modelContext.delete(existing)
        } else {
            let completion = Completion(date: date)
            habit.completions.append(completion)
        }
    }
}
