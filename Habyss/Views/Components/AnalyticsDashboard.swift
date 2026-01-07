import SwiftUI

struct AnalyticsDashboard: View {
    var habits: [Habit]
    var completions: [String: Bool] // Today's completions for calculation? Or passing in computed scores?
    
    // Hardcoded Categories matching Expo
    let categories: [BalanceCategory] = [
        BalanceCategory(key: "body", label: "BODY", color: .habyssCoral, icon: "figure.run"),
        BalanceCategory(key: "wealth", label: "WEALTH", color: Color(hex: "F59E0B"), icon: "briefcase.fill"),
        BalanceCategory(key: "heart", label: "HEART", color: Color(hex: "EC4899"), icon: "heart.fill"),
        BalanceCategory(key: "mind", label: "MIND", color: .habyssBlue, icon: "lightbulb.fill"),
        BalanceCategory(key: "soul", label: "SOUL", color: .habyssPurple, icon: "sparkles"),
        BalanceCategory(key: "play", label: "PLAY", color: .habyssTeal, icon: "gamecontroller.fill")
    ]
    
    // Mock Data Calculation (same logic as Expo: base 0.2 + 0.8 * percentage)
    var radarValues: [Double] {
        categories.map { cat in
            let catHabits = habits.filter { $0.category.lowercased() == cat.key }
            if catHabits.isEmpty { return 0.2 }
            let completed = catHabits.filter { completions[$0.id] ?? false }.count // This should really be historical consistency but sticking to simple mock or today's
            let score = Double(completed) / Double(catHabits.count)
            return 0.3 + (score * 0.7) // Matches Expo logic
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Life Balance Matrix Card
            VoidCard(intensity: 90.0, cornerRadius: 24) {
                VStack {
                    Text("LIFE BALANCE MATRIX")
                        .font(.system(size: 10, weight: .bold)) // Lexend 10, 700
                        .tracking(2)
                        .foregroundStyle(Color.white.opacity(0.5))
                        .padding(.top, 16)
                    
                    RadarChart(values: radarValues, labels: categories.map { $0.label })
                        .frame(height: 300)
                        .padding(.bottom, 16)
                }
            }
            
            // Today's Completion Card
            let done = habits.filter { completions[$0.id] ?? false }.count
            let total = habits.count
            let progress = total > 0 ? Int((Double(done) / Double(total)) * 100) : 0
            
            VoidCard(intensity: 90.0, cornerRadius: 16) {
                HStack {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(LinearGradient(colors: [.habyssBlue, .habyssPurple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 36, height: 36)
                            .overlay(Image(systemName: "chart.pie.fill").font(.caption).foregroundStyle(.white))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TODAY'S COMPLETION")
                                .font(.system(size: 10))
                                .tracking(1)
                                .foregroundStyle(Color.white.opacity(0.5))
                            
                            Text("\(done)/\(total) habits done")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(progress)%")
                        .font(.system(size: 28, weight: .black)) // Lexend 900
                        .foregroundStyle(.white)
                }
                .padding(16)
            }
        }
    }
}

struct BalanceCategory {
    let key: String
    let label: String
    let color: Color
    let icon: String
}

// Custom Radar Chart Implementation
struct RadarChart: View {
    let values: [Double] // 0.0 to 1.0
    let labels: [String]
    
    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 40 // Padding for labels
            let count = values.count
            let angleSlice = (2 * .pi) / Double(count)
            
            ZStack {
                // 1. Grid Levels (0.25, 0.5, 0.75, 1.0)
                ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { level in
                    Path { path in
                        for i in 0..<count {
                            let angle = Double(i) * angleSlice - .pi / 2
                            let r = radius * level
                            let point = CGPoint(
                                x: center.x + CGFloat(cos(angle)) * r,
                                y: center.y + CGFloat(sin(angle)) * r
                            )
                            if i == 0 { path.move(to: point) }
                            else { path.addLine(to: point) }
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .fill(level == 1.0 ? Color.white.opacity(0.02) : Color.clear)
                }
                
                // 2. Axis Lines
                Path { path in
                    for i in 0..<count {
                        let angle = Double(i) * angleSlice - .pi / 2
                        let point = CGPoint(
                            x: center.x + CGFloat(cos(angle)) * radius,
                            y: center.y + CGFloat(sin(angle)) * radius
                        )
                        path.move(to: center)
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                // 3. Data Polygon
                Path { path in
                    for i in 0..<count {
                        let angle = Double(i) * angleSlice - .pi / 2
                        let r = radius * CGFloat(values[i])
                        let point = CGPoint(
                            x: center.x + CGFloat(cos(angle)) * r,
                            y: center.y + CGFloat(sin(angle)) * r
                        )
                        if i == 0 { path.move(to: point) }
                        else { path.addLine(to: point) }
                    }
                    path.closeSubpath()
                }
                .fill(LinearGradient(colors: [.habyssBlue.opacity(0.4), .habyssPink.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                
                Path { path in
                     for i in 0..<count {
                        let angle = Double(i) * angleSlice - .pi / 2
                        let r = radius * CGFloat(values[i])
                        let point = CGPoint(
                            x: center.x + CGFloat(cos(angle)) * r,
                            y: center.y + CGFloat(sin(angle)) * r
                        )
                        if i == 0 { path.move(to: point) }
                        else { path.addLine(to: point) }
                    }
                    path.closeSubpath()
                }
                .stroke(Color.habyssPurple, lineWidth: 2)
                
                // 4. Data Points
                ForEach(0..<count, id: \.self) { i in
                    let angle = Double(i) * angleSlice - .pi / 2
                    let r = radius * CGFloat(values[i])
                    let x = center.x + CGFloat(cos(angle)) * r
                    let y = center.y + CGFloat(sin(angle)) * r
                    
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.habyssPurple, lineWidth: 2)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
                
                // 5. Labels
                ForEach(0..<count, id: \.self) { i in
                    let angle = Double(i) * angleSlice - .pi / 2
                    let r = radius + 20 // Offset
                    let x = center.x + CGFloat(cos(angle)) * r
                    let y = center.y + CGFloat(sin(angle)) * r
                    
                    Text(labels[i])
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .position(x: x, y: y)
                }
            }
        }
    }
}

// Pink color extension removed to avoid invalid redeclaration
