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

struct GlassDock: View {
    @Binding var selectedTab: MainTabView.Tab
    @State private var showCreationModal = false
    
    var body: some View {
        VoidCard(intensity: 90, cornerRadius: 40) {
            HStack(spacing: 0) {
                TabButton(icon: "house.fill", tab: .home, selected: $selectedTab)
                TabButton(icon: "calendar", tab: .roadmap, selected: $selectedTab)
                
                // Central Action Button (Add)
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
                            .frame(width: 50, height: 50)
                            .shadow(color: .habyssBlue.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .offset(y: -20)
                .padding(.horizontal, 10)
                .sheet(isPresented: $showCreationModal) {
                    HabitCreationView()
                        .presentationDetents([.fraction(0.8), .large])
                        .presentationDragIndicator(.visible)
                }
                
                TabButton(icon: "person.2.fill", tab: .community, selected: $selectedTab)
                TabButton(icon: "person.fill", tab: .profile, selected: $selectedTab)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .frame(height: 70)
    }
    
    struct TabButton: View {
        var icon: String
        var tab: MainTabView.Tab
        @Binding var selected: MainTabView.Tab
        
        var body: some View {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selected = tab
                }
            } label: {
                VStack {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(selected == tab ? Color.habyssBlue : Color.textSecondary)
                        .scaleEffect(selected == tab ? 1.1 : 1.0)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// Temporary Placeholders for Screens
struct HomeScreen: View { var body: some View { Color.habyssBlack.ignoresSafeArea() } }
struct RoadmapScreen: View { var body: some View { Color.habyssBlack.ignoresSafeArea() } }
struct CommunityScreen: View { var body: some View { Color.habyssBlack.ignoresSafeArea() } }
struct ProfileScreen: View { var body: some View { Color.habyssBlack.ignoresSafeArea() } }

#Preview {
    MainTabView()
}
