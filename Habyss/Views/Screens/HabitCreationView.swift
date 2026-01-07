import SwiftUI
import SwiftData

struct HabitCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Habit> { $0.isGoal }) var availableGoals: [Habit]
    
    @State private var inputName: String = ""
    @State private var selectedCategory: String = "body"
    @State private var selectedColor: String = "#8BADD6"
    @State private var taskDays: Set<String> = Set(["mon", "tue", "wed", "thu", "fri", "sat", "sun"])
    @State private var isGoal: Bool = false
    @State private var targetDate: Date = Date().addingTimeInterval(86400 * 30) // Default 30 days
    @State private var selectedParentGoal: Habit?
    
    let categories = ["body", "wealth", "heart", "mind", "soul", "play"]
    let colors = ["#8BADD6", "#7B2CBF", "#FF4757", "#4ECDC4", "#FFD93D", "#A78BFA"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Type Selection (Habit vs Goal)
                        HStack(spacing: 0) {
                            Button(action: { isGoal = false }) {
                                Text("HABIT")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(!isGoal ? Color.habyssBlue.opacity(0.3) : Color.clear)
                                    .foregroundStyle(!isGoal ? .white : Color.textTertiary)
                            }
                            Rectangle().fill(Color.white.opacity(0.1)).frame(width: 1)
                            Button(action: { isGoal = true }) {
                                Text("GOAL")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(isGoal ? Color.habyssBlue.opacity(0.3) : Color.clear)
                                    .foregroundStyle(isGoal ? .white : Color.textTertiary)
                            }
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Name Input
                        VoidCard(intensity: 60, cornerRadius: 16) {
                            TextField(isGoal ? "Goal Name" : "Habit Name", text: $inputName)
                                .font(.title3)
                                .foregroundStyle(Color.textPrimary)
                                .padding(.horizontal)
                                .overlay(
                                    HStack {
                                        if inputName.isEmpty {
                                            Text(isGoal ? "e.g. Learn Spanish" : "e.g. Morning Run")
                                                .foregroundStyle(Color.textTertiary)
                                                .allowsHitTesting(false)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                )
                        }
                        .frame(height: 60)
                        
                        // Goal Specific Fields
                        if isGoal {
                            VStack(alignment: .leading) {
                                Text("TARGET DATE")
                                    .font(.caption).fontWeight(.bold).foregroundStyle(Color.textSecondary).padding(.horizontal)
                                
                                DatePicker("", selection: $targetDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        } else {
                            // Habit Specific: Parent Goal
                            VStack(alignment: .leading) {
                                Text("LINK TO GOAL (Optional)")
                                    .font(.caption).fontWeight(.bold).foregroundStyle(Color.textSecondary).padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        Button(action: { selectedParentGoal = nil }) {
                                            Text("None")
                                                .font(.subheadline)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedParentGoal == nil ? Color.habyssBlue : Color.white.opacity(0.05))
                                                .foregroundStyle(.white)
                                                .cornerRadius(20)
                                        }
                                        
                                        ForEach(availableGoals) { goal in
                                            Button(action: { selectedParentGoal = goal }) {
                                                Text(goal.name)
                                                    .font(.subheadline)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(selectedParentGoal?.id == goal.id ? Color.habyssBlue : Color.white.opacity(0.05))
                                                    .foregroundStyle(.white)
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Category Picker
                        VStack(alignment: .leading) {
                            Text("CATEGORY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(categories, id: \.self) { category in
                                        Button {
                                            selectedCategory = category
                                        } label: {
                                            Text(category.capitalized)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundStyle(selectedCategory == category ? .white : .gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(selectedCategory == category ? Color.habyssBlue.opacity(0.3) : Color.white.opacity(0.05))
                                                )
                                                .overlay(
                                                    Capsule()
                                                        .stroke(selectedCategory == category ? Color.habyssBlue : Color.clear, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Color Picker
                        VStack(alignment: .leading) {
                            Text("COLOR Theme")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                ForEach(colors, id: \.self) { color in
                                    Button {
                                        selectedColor = color
                                    } label: {
                                        Circle()
                                            .fill(Color(hex: color))
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: selectedColor == color ? 2 : 0)
                                                    .padding(-4)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Schedule (Only for Habits, typically Goals are purely deadline based or period based, but for simplicity keeping schedule for both or hiding for Goal)
                        if !isGoal {
                            VStack(alignment: .leading) {
                                Text("SCHEDULE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(.horizontal)
                                
                                HStack(spacing: 8) {
                                    ForEach(["sun", "mon", "tue", "wed", "thu", "fri", "sat"], id: \.self) { day in
                                        Button {
                                            if taskDays.contains(day) {
                                                taskDays.remove(day)
                                            } else {
                                                taskDays.insert(day)
                                            }
                                        } label: {
                                            Text(day.prefix(1).capitalized)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundStyle(taskDays.contains(day) ? .white : .gray)
                                                .frame(width: 36, height: 36)
                                                .background(
                                                    Circle()
                                                        .fill(taskDays.contains(day) ? Color.habyssBlue : Color.white.opacity(0.05))
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(isGoal ? "New Goal" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createHabit()
                    }
                    .font(.headline)
                    .foregroundStyle(Color.habyssBlue)
                    .disabled(inputName.isEmpty)
                }
            }
        }
    }
    
    func createHabit() {
        let habit = Habit(
            name: inputName,
            category: selectedCategory,
            color: selectedColor,
            taskDays: Array(taskDays),
            isGoal: isGoal,
            goalId: isGoal ? nil : selectedParentGoal?.id, // Link to parent
            targetDate: isGoal ? targetDate : nil
        )
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    HabitCreationView()
}
