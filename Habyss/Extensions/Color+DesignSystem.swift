import SwiftUI

extension Color {
    // MARK: - Abyss Theme (Default)
    static let habyssBlack = Color(hex: "050505")
    static let habyssVoid = Color(hex: "000000") // Pure black for depth
    static let habyssBlue = Color(hex: "8BADD6")
    static let habyssPurple = Color(hex: "7B2CBF")
    static let habyssDarkBlue = Color(hex: "0A0F14")
    static let habyssNavy = Color(hex: "121826")
    static let habyssCoral = Color(hex: "FF4757")
    static let habyssPink = Color(hex: "EC4899")
    static let habyssTeal = Color(hex: "4ECDC4")
    
    // MARK: - Text
    static let textPrimary = Color(hex: "E0E6ED")
    static let textSecondary = Color(hex: "94A3B8")
    static let textTertiary = Color(hex: "64748B")
    
    // MARK: - Gradients
    static let voidGradientStart = Color(hex: "0A0F14")
    static let voidGradientEnd = Color(hex: "050505")
    
    // MARK: - UI Elements
    static let glassBorder = Color.white.opacity(0.08)
    static let glassSurface = Color.white.opacity(0.05)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
