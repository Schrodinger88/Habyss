import SwiftUI

struct NotificationsView: View {
    @Binding var isPresented: Bool
    
    // Mock Data
    @State private var notifications: [MockNotification] = [
        MockNotification(title: "Hydration", message: "Time to drink water.", type: .habit, time: "2m ago"),
        MockNotification(title: "New Friend Request", message: "@jason wants to follow you.", type: .info, time: "1h ago"),
        MockNotification(title: "Streak Danger", message: "You are about to lose your 12 day streak!", type: .warning, time: "3h ago"),
        MockNotification(title: "Level Up", message: "You reached Level 5 consistency.", type: .success, time: "Yesterday")
    ]
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "arrow.left")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("NOTIFICATIONS")
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                        Text("\(notifications.count) UNREAD")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.habyssGreen)
                            .tracking(1)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: { notifications.removeAll() }) {
                        Image(systemName: "checkmark.circle")
                            .font(.headline)
                            .foregroundStyle(Color.habyssGreen)
                            .frame(width: 40, height: 40)
                            .background(Color.habyssGreen.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                // List
                ScrollView {
                    VStack(spacing: 12) {
                        if notifications.isEmpty {
                            ContentUnavailableView("All Caught Up", systemImage: "bell.slash.fill", description: Text("No new notifications."))
                                .foregroundStyle(Color.textSecondary)
                                .padding(.top, 60)
                        } else {
                            ForEach(notifications) { notif in
                                NotificationRow(notification: notif)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct MockNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let type: NotificationType
    let time: String
}

enum NotificationType {
    case success, warning, habit, info
    
    var color: Color {
        switch self {
        case .success: return .habyssGreen
        case .warning: return .habyssCoral
        case .habit: return .habyssBlue
        case .info: return .textSecondary
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "trophy.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .habit: return "clock.fill"
        case .info: return "bell.fill"
        }
    }
}

struct NotificationRow: View {
    let notification: MockNotification
    
    var body: some View {
        VoidCard(intensity: 30, cornerRadius: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(notification.type.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: notification.type.icon)
                        .foregroundStyle(notification.type.color)
                        .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.title)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        Circle()
                            .fill(Color.habyssGreen)
                            .frame(width: 6, height: 6)
                    }
                    
                    Text(notification.message)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                    
                    Text(notification.time)
                        .font(.caption2)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .padding(12)
        }
    }
}
