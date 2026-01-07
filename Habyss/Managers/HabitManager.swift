import Foundation
import SwiftData
import SwiftUI

@Observable
class HabitManager {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - CRUD
    
    func addHabit(name: String, category: String = "body") {
        let habit = Habit(name: name, category: category)
        modelContext.insert(habit)
    }
    
    func deleteHabit(_ habit: Habit) {
        modelContext.delete(habit)
    }
    
    func updateHabit(_ habit: Habit) {
        // SwiftData autosaves changes to managed objects, but explicit save might be needed for instant UI updates if not using @Query binding directly
        try? modelContext.save()
    }
    
    // MARK: - Completion Logic
    
    func isCompleted(habit: Habit, date: Date) -> Bool {
        let calendar = Calendar.current
        return habit.completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: date)
        }
    }
    
    func toggleCompletion(habit: Habit, date: Date) {
        let calendar = Calendar.current
        
        if let existingCompletion = habit.completions.first(where: {
            calendar.isDate($0.date, inSameDayAs: date)
        }) {
            // Remove completion
            // We need to delete from context and remove from relationship
            modelContext.delete(existingCompletion)
            if let index = habit.completions.firstIndex(of: existingCompletion) {
                habit.completions.remove(at: index)
            }
        } else {
            // Add completion
            let completion = Completion(date: date)
            habit.completions.append(completion)
        }
        
        try? modelContext.save()
    }
    
    // MARK: - Stats Logic
    
    func calculateStreak(habit: Habit) -> Int {
        // Simplified Streak Logic
        // Sort completions by date descending
        let sortedCompletions = habit.completions.sorted { $0.date > $1.date }
        
        let calendar = Calendar.current
        var streak = 0

        
        // Check if completed today or yesterday to start streak
        guard let first = sortedCompletions.first else { return 0 }
        
        if !calendar.isDateInToday(first.date) && !calendar.isDateInYesterday(first.date) {
            return 0
        }
        
        var currentDate = first.date
        
        for completion in sortedCompletions {
            if calendar.isDate(completion.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if calendar.isDate(completion.date, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: currentDate)!) {
                // Duplicate or same day check handled above, this handles if dates are exactly expected
                continue
            } else {
                break
            }
        }
        return streak
    }
}
