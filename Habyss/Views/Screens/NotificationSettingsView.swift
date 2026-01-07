import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Mock State
    @State private var pushEnabled = true
    @State private var habitReminders = true
    @State private var streakAlerts = true
    @State private var weeklyReport = true
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color.textPrimary)
                    }
                    Spacer()
                    Text("Notifications")
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding()
                .background(Color.habyssBlack)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Main Toggle
                        VoidCard(intensity: 20, cornerRadius: 16) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.habyssBlue)
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Push Notifications")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.textPrimary)
                                    Text("Enable all notifications")
                                        .font(.caption)
                                        .foregroundStyle(Color.textSecondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $pushEnabled)
                                    .labelsHidden()
                                    .tint(Color.habyssBlue) // iOS Toggle color
                            }
                            .padding()
                        }
                        
                        // Specific Toggles
                        VoidCard(intensity: 20, cornerRadius: 16) {
                            VStack(spacing: 0) {
                                ToggleRow(icon: "alarm", title: "Habit Reminders", isOn: $habitReminders)
                                Divider().background(Color.white.opacity(0.1))
                                ToggleRow(icon: "flame", title: "Streak Alerts", isOn: $streakAlerts)
                                Divider().background(Color.white.opacity(0.1))
                                ToggleRow(icon: "chart.bar", title: "Weekly Report", isOn: $weeklyReport)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 32)
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.habyssTeal) // Specific toggles use Teal as per screenshot
        }
        .padding()
    }
}
