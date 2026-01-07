import SwiftUI

struct ProfileScreen: View {
    @State private var showEditProfile = false
    @State private var isPremium = true // Mocked
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Spacer for Header
                        Color.clear.frame(height: 60)
                        
                        // Profile Section
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.habyssNavy) // Placeholder
                                    .frame(width: 88, height: 88)
                                    .overlay(Text("E").font(.largeTitle).fontWeight(.bold).foregroundStyle(.white))
                                
                                if isPremium {
                                    Circle()
                                        .stroke(LinearGradient(colors: [.habyssBlue, .habyssPurple, .habyssPink], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                        .frame(width: 94, height: 94)
                                    
                                    // Pro Badge
                                    VStack {
                                        Spacer()
                                        Text("PRO")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(LinearGradient(colors: [.habyssBlue, .habyssPurple], startPoint: .leading, endPoint: .trailing))
                                            .cornerRadius(6)
                                            .offset(y: 10)
                                    }
                                    .frame(height: 94)
                                }
                            }
                            .onTapGesture {
                                showEditProfile = true
                            }
                            
                            VStack(spacing: 4) {
                                Text("Erwan")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.textPrimary)
                                Text("traveler@habyss.com")
                                    .font(.caption)
                                    .foregroundStyle(Color.textTertiary)
                            }
                            
                            if !isPremium {
                                Button(action: {}) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "sparkles")
                                        Text("Upgrade to Pro")
                                    }
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(LinearGradient(colors: [.habyssBlue, .habyssPurple], startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(20)
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Settings Sections
                        VStack(spacing: 24) {
                            SettingsSection(title: "APP PREFERENCES") {
                                SettingsRow(icon: "sparkles", iconColor: .habyssPurple, title: "AI Personality", subtitle: "Customize your AI coach", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "bell", iconColor: .habyssBlue, title: "Notifications", subtitle: "Manage alerts & reminders", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "paintpalette", iconColor: .habyssPink, title: "Appearance", subtitle: "Theme, colors, & display", action: {})
                            }
                            
                            SettingsSection(title: "DATA & SYNC") {
                                SettingsRow(icon: "icloud.and.arrow.up", iconColor: .green, title: "Backup & Restore", subtitle: "Cloud sync & data export", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "link", iconColor: .habyssBlue, title: "Integrations", subtitle: "Calendar, Health", action: {})
                            }
                            
                            SettingsSection(title: "ACCOUNT") {
                                SettingsRow(icon: "star", iconColor: .habyssPurple, title: "Subscription", subtitle: "Manage your plan", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "shield.checkerboard", iconColor: .orange, title: "Privacy & Security", subtitle: "Data & security options", action: {})
                            }
                            
                            SettingsSection(title: "SUPPORT") {
                                SettingsRow(icon: "questionmark.circle", iconColor: .gray, title: "Help Center", subtitle: "FAQs and guides", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "envelope", iconColor: .gray, title: "Contact Support", subtitle: "Get help from our team", action: {})
                                Divider().background(Color.white.opacity(0.1))
                                SettingsRow(icon: "info.circle", iconColor: .gray, title: "About Habyss", subtitle: "Version 1.0.4 • Void Build", action: {})
                            }
                        }
                        
                        // Sign Out
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                            }
                            .foregroundStyle(Color.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.bottom, 20)
                        
                        // Footer
                        VStack(spacing: 4) {
                            Text("\"Descend into discipline\"")
                                .font(.caption)
                                .italic()
                                .foregroundStyle(Color.textTertiary)
                            Text("v1.0.4 • Void Build")
                                .font(.caption2)
                                .foregroundStyle(Color.textTertiary.opacity(0.6))
                        }
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal)
                }
                
                // Fixed Header
                VStack {
                    HStack {
                        Spacer()
                        Text("PROFILE")
                            .font(.system(size: 24, weight: .black)) // Lexend 900
                            .tracking(0)
                            .foregroundStyle(Color.textPrimary)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.habyssBlack.opacity(0.9).blur(radius: 10).ignoresSafeArea(edges: .top))
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.textTertiary)
                .padding(.leading, 4)
            
            VoidCard(intensity: 30, cornerRadius: 16) {
                VStack(spacing: 0) {
                    content
                }
                .padding(4)
            }
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var iconColor: Color
    var title: String
    var subtitle: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                        .font(.system(size: 16))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundStyle(Color.textPrimary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(12)
        }
    }
}
