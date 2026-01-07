import Foundation
import SwiftData

@Model
final class Completion {
    var id: UUID
    var date: Date // Use normalized date (noon or midnight) to avoid timezone issues
    var value: Double // For numeric habits
    
    @Relationship(inverse: \Habit.completions) var habit: Habit?
    
    init(id: UUID = UUID(), date: Date, value: Double = 1.0) {
        self.id = id
        self.date = date
        self.value = value
    }
}
