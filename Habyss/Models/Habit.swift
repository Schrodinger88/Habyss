import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var userId: String // iCloud Record ID if available, or just a placeholder for now
    var name: String
    var details: String? // Description
    var icon: String?
    var category: String // Raw value of HabitCategory
    var type: String // Raw value of HabitType
    var color: String
    
    // Scheduling
    var startDate: Date
    var endDate: Date?
    var taskDays: [String] // ["mon", "tue", ...]
    var reminders: [String]
    
    // Goals
    var isGoal: Bool
    var goalPeriod: String // "daily", "weekly", "monthly"
    var goalValue: Int
    var unit: String
    var targetDate: Date?
    
    // Metadata
    var createdAt: Date
    var isArchived: Bool
    var showMemo: Bool
    
    // Relationships
    @Relationship(deleteRule: .cascade) var completions: [Completion] = []
    
    init(
        id: UUID = UUID(),
        userId: String = "",
        name: String,
        details: String? = nil,
        icon: String? = nil,
        category: String = "body",
        type: String = "build",
        color: String = "#6B46C1",
        startDate: Date = Date(),
        endDate: Date? = nil,
        taskDays: [String] = [],
        reminders: [String] = [],
        isGoal: Bool = false,
        goalPeriod: String = "daily",
        goalValue: Int = 1,
        unit: String = "count",
        targetDate: Date? = nil,
        createdAt: Date = Date(),
        isArchived: Bool = false,
        showMemo: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.details = details
        self.icon = icon
        self.category = category
        self.type = type
        self.color = color
        self.startDate = startDate
        self.endDate = endDate
        self.taskDays = taskDays
        self.reminders = reminders
        self.isGoal = isGoal
        self.goalPeriod = goalPeriod
        self.goalValue = goalValue
        self.unit = unit
        self.targetDate = targetDate
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.showMemo = showMemo
    }
}
