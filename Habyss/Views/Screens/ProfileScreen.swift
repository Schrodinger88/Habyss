import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.habyssNavy)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.habyssBlue)
                            )
                        
                        VStack(spacing: 4) {
                            Text("Traveler") // TODO: Fetch name
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textPrimary)
                            
                            Text("Level 1 • Novice")
                                .font(.caption)
                                .foregroundStyle(Color.habyssPurple)
                        }
                    }
                    .padding(.top, 40)
                    
                    // Stats Grid
                    HStack(spacing: 12) {
                        VoidCard(intensity: 60, cornerRadius: 16) {
                            VStack(spacing: 4) {
                                Text("12")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("HABITS")
                                    .font(.caption2)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        VoidCard(intensity: 60, cornerRadius: 16) {
                            VStack(spacing: 4) {
                                Text("85%")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("COMPLETION")
                                    .font(.caption2)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Settings Menu
                    VStack(spacing: 16) {
                        SettingsRow(icon: "gearshape.fill", title: "General Settings")
                        SettingsRow(icon: "bell.fill", title: "Notifications")
                        SettingsRow(icon: "lock.fill", title: "Privacy & Data")
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        SettingsRow(icon: "star.fill", title: "Rate Habyss", color: .habyssBlue)
                        SettingsRow(icon: "message.fill", title: "Contact Support", color: .habyssBlue)
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var title: String
    var color: Color = .textSecondary
    
    var body: some View {
        VoidCard(intensity: 40, cornerRadius: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            .contentShape(Rectangle())
        }
        .frame(height: 50)
    }
}

#Preview {
    ProfileScreen()
}
