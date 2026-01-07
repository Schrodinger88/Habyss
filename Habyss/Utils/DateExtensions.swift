import Foundation

extension Date {
    static var today: Date {
        return Date()
    }
    
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
