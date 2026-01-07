import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, roadmap, community, profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .tag(Tab.home)
                
                RoadmapScreen()
                    .tag(Tab.roadmap)
                
                CommunityScreen()
                    .tag(Tab.community)
                
                ProfileScreen()
                    .tag(Tab.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Swipeable or just hide defaults
            .ignoresSafeArea()
            
            // Custom Glass Dock
            GlassDock(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}

// Custom Glass Dock matching Expo layout (Split Pill + Orb)
struct GlassDock: View {
    @Binding var selectedTab: MainTabView.Tab
    @State private var showCreationModal = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // 1. Navigation Pill
            ZStack {
                // Blur Background
                Capsule()
                    .fill(.ultraThinMaterial)
                
                // Glass Border
                Capsule()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                HStack(spacing: 0) {
                    TabButton(icon: "house.fill", tab: .home, selected: $selectedTab)
                    TabButton(icon: "map.fill", tab: .roadmap, selected: $selectedTab) // Calendar/Roadmap
                    TabButton(icon: "person.3.fill", tab: .community, selected: $selectedTab)
                    TabButton(icon: "gearshape.fill", tab: .profile, selected: $selectedTab) // Settings/Profile logic uses Gear icon
                }
            }
            .frame(height: 64)
            .frame(maxWidth: 280) // Constrain width like Expo
            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 4)
            
            // 2. Creation Orb (Floating Action Button)
            Button {
                showCreationModal = true
            } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.habyssBlue, .habyssPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .bold)) // Larger icon
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 64, height: 64)
            .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 4)
            .sheet(isPresented: $showCreationModal) {
                HabitCreationView()
                    .presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    struct TabButton: View {
        var icon: String
        var tab: MainTabView.Tab
        @Binding var selected: MainTabView.Tab
        
        var body: some View {
            Button {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selected = tab
                }
            } label: {
                VStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundStyle(selected == tab ? Color.habyssBlue : Color.white.opacity(0.4)) // Match Expo icon colors
                        .scaleEffect(selected == tab ? 1.15 : 1.0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
            }
        }
    }
}

// Temporary Placeholders for Screens

#Preview {
    MainTabView()
}
