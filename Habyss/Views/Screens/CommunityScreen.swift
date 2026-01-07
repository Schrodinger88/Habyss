import SwiftUI

struct CommunityScreen: View {
    @State private var showAddFriend = false
    @State private var searchText = ""
    
    // Mock Data Models matches Expo structure
    struct Friend: Identifiable {
        let id = UUID()
        let name: String
        let streak: Int
        let completion: Int // 0-100
        let rank: Int
        let avatar: String?
        let lastActivity: String
    }
    
    struct Activity: Identifiable {
        let id = UUID()
        let username: String
        let habitName: String
        let icon: String
        let timeAgo: String
        let avatar: String?
    }
    
    let friends = [
        Friend(name: "You", streak: 12, completion: 85, rank: 4, avatar: nil, lastActivity: "Just now"),
        Friend(name: "Alex", streak: 45, completion: 98, rank: 1, avatar: "person.crop.circle.fill", lastActivity: "2h ago"),
        Friend(name: "Sarah", streak: 30, completion: 92, rank: 2, avatar: "person.crop.circle", lastActivity: "5h ago"),
        Friend(name: "Mike", streak: 21, completion: 40, rank: 3, avatar: nil, lastActivity: "Yesterday")
    ].sorted { $0.rank < $1.rank }
    
    let activities = [
        Activity(username: "Alex", habitName: "Morning Run", icon: "figure.run", timeAgo: "2m ago", avatar: "person.crop.circle.fill"),
        Activity(username: "Sarah", habitName: "Read 30m", icon: "book.fill", timeAgo: "2h ago", avatar: "person.crop.circle")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.habyssBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Spacer for Header
                        
                        // 1. Shared With You (Mock conditional)
                        // Skipped for now as it's empty state usually
                        
                        // 2. Recent Activity Feed
                        if !activities.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("RECENT ACTIVITY")
                                    .font(.system(size: 10, weight: .bold)) // Lexend 600
                                    .tracking(1)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(.horizontal)
                                
                                ForEach(activities) { activity in
                                    VoidCard(intensity: 40, cornerRadius: 16) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                AvatarView(name: activity.username, url: activity.avatar, size: 32)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(activity.username)
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundStyle(Color.textPrimary)
                                                    
                                                    HStack(spacing: 4) {
                                                        Image(systemName: activity.icon)
                                                            .font(.caption2)
                                                            .foregroundStyle(Color.habyssTeal)
                                                        Text("Completed \(activity.habitName)")
                                                            .font(.caption)
                                                            .foregroundStyle(Color.textSecondary)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Text(activity.timeAgo)
                                                    .font(.caption2)
                                                    .foregroundStyle(Color.textTertiary)
                                            }
                                            
                                            // Reactions
                                            HStack(spacing: 8) {
                                                ReactionButton(emoji: "🔥")
                                                ReactionButton(emoji: "👏")
                                                ReactionButton(emoji: "💪")
                                            }
                                        }
                                        .padding(16)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // 3. Pending Requests placeholder
                        // Skipped
                        
                        // 4. Your Crew (Detailed List)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("YOUR CREW (\(friends.count))")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(1)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            VoidCard(intensity: 20, cornerRadius: 16) {
                                VStack(spacing: 0) {
                                    ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                                        CrewRow(friend: friend)
                                        if index < friends.count - 1 {
                                            Divider().background(Color.white.opacity(0.05))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // 5. Leaderboard
                        VStack(alignment: .leading, spacing: 12) {
                            Text("FRIEND LEADERBOARD")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(1)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            VoidCard(intensity: 80, cornerRadius: 16) {
                                VStack(spacing: 0) {
                                    ForEach(friends) { friend in
                                        LeaderboardRow(friend: friend)
                                            .padding(.horizontal, 16)
                                        
                                        if friend.id != friends.last?.id {
                                            Divider().background(Color.white.opacity(0.05))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                // Fixed Header
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("COMMUNITY")
                                .font(.system(size: 24, weight: .black))
                                .tracking(-1) // Lexend 900
                                .foregroundStyle(Color.textPrimary)
                            Text("CREW STATUS")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(2)
                                .foregroundStyle(Color.habyssBlue)
                        }
                        
                        Spacer()
                        
                        Button {
                            showAddFriend = true
                        } label: {
                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "person.badge.plus")
                                        .foregroundStyle(Color.habyssBlue)
                                        .font(.system(size: 18))
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .background(Color.habyssBlack.opacity(0.9).blur(radius: 10).ignoresSafeArea(edges: .top))
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Components

struct AvatarView: View {
    let name: String
    let url: String?
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
            
            if let url = url {
                Image(systemName: url) // Mock using system images for now
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .foregroundStyle(.white)
            } else {
                Text(String(name.prefix(1)))
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .frame(width: size, height: size)
    }
}

struct ReactionButton: View {
    let emoji: String
    @State private var isSelected = false
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack(spacing: 4) {
                Text(emoji).font(.system(size: 14))
                if isSelected {
                    Text("1").font(.caption2).foregroundStyle(Color.textSecondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Color.habyssBlue.opacity(0.2) : Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.habyssBlue : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct CrewRow: View {
    let friend: CommunityScreen.Friend
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AvatarView(name: friend.name, url: friend.avatar, size: 42)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(friend.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(Color(hex: "FFD93D")) // Gold
                            .font(.caption2)
                        Text("\(friend.streak)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFD93D"))
                    }
                }
                
                // Progress Bar
                VStack(spacing: 4) {
                    HStack {
                        Text("Today's Progress")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.textTertiary)
                        Spacer()
                        Text("\(friend.completion)%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.habyssTeal)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.1))
                            Capsule()
                                .fill(friend.completion >= 100 ? Color.habyssTeal : Color.habyssBlue)
                                .frame(width: geo.size.width * CGFloat(friend.completion) / 100)
                        }
                    }
                    .frame(height: 6)
                }
            }
            
            // Nudge Button
            Button(action: {}) {
                Text("👋")
                    .font(.caption)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.habyssBlue, lineWidth: 1))
            }
        }
        .padding(16)
    }
}

struct LeaderboardRow: View {
    let friend: CommunityScreen.Friend
    
    func getRankEmoji(_ rank: Int) -> String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(getRankEmoji(friend.rank))
                .font(.system(size: 14))
                .frame(width: 24, alignment: .center)
                .foregroundStyle(friend.rank <= 3 ? Color(hex: "FFD93D") : Color.textTertiary)
            
            AvatarView(name: friend.name, url: friend.avatar, size: 24)
            
            Text(friend.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(friend.name == "You" ? Color.habyssBlue : Color.textPrimary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(Color(hex: "FFD93D"))
                    .font(.caption2)
                Text("\(friend.streak)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    CommunityScreen()
}
