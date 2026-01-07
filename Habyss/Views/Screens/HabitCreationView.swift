import SwiftUI
import SwiftData

struct HabitCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var selectedCategory: String = "body"
    @State private var selectedColor: String = "#8BADD6"
    @State private var taskDays: Set<String> = Set(["mon", "tue", "wed", "thu", "fri", "sat", "sun"])
    
    let categories = ["body", "wealth", "heart", "mind", "soul", "play"]
    let colors = ["#8BADD6", "#7B2CBF", "#FF4757", "#4ECDC4", "#FFD93D", "#A78BFA"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Name Input
                        VoidCard(intensity: 60, cornerRadius: 16) {
                            TextField("Habit Name", text: $name)
                                .font(.title3)
                                .foregroundStyle(Color.textPrimary)
                                .padding(.horizontal)
                                // Placeholder style
                                .overlay(
                                    HStack {
                                        if name.isEmpty {
                                            Text("e.g. Morning Run")
                                                .foregroundStyle(Color.textTertiary)
                                                .allowsHitTesting(false)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                )
                        }
                        .frame(height: 60)
                        
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
                        
                        // Schedule
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
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Habit")
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
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func createHabit() {
        let habit = Habit(
            name: name,
            category: selectedCategory,
            color: selectedColor,
            taskDays: Array(taskDays)
        )
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    HabitCreationView()
}
