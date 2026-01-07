struct CommunityScreen: View {
    @State private var selectedSegment = 0
    @State private var searchText = ""
    
    // Mock Data
    struct Friend: Identifiable {
        let id = UUID()
        let name: String
        let streak: Int
        let completion: Int
        let rank: Int
    }
    
    let friends = [
        Friend(name: "You", streak: 12, completion: 85, rank: 4),
        Friend(name: "Alex", streak: 45, completion: 98, rank: 1),
        Friend(name: "Sarah", streak: 30, completion: 92, rank: 2),
        Friend(name: "Mike", streak: 21, completion: 88, rank: 3)
    ].sorted { $0.rank < $1.rank }
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("COMMUNITY")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.textPrimary)
                    
                    Picker("View", selection: $selectedSegment) {
                        Text("Leaderboard").tag(0)
                        Text("Friends").tag(1)
                        Text("Requests").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.habyssBlue) // Tint the picker
                }
                .padding(.horizontal)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if selectedSegment == 0 {
                    // LEADERBOARD VIEW
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("WEEKLY RANKING")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(2)
                                .foregroundStyle(Color.habyssBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VoidCard(intensity: 60, cornerRadius: 20) {
                                VStack(spacing: 0) {
                                    ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                                        LeaderboardRow(friend: friend, index: index, count: friends.count)
                                    }
                                }
                                .padding(16)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 100)
                    }
                } else if selectedSegment == 1 {
                    // FRIENDS / FEED VIEW
                    ScrollView {
                        VStack(spacing: 20) {
                            // Search
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color.textTertiary)
                                TextField("Find friends...", text: $searchText)
                                    .foregroundStyle(Color.textPrimary)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            // Activity Feed Placeholder
                            VStack(alignment: .leading, spacing: 12) {
                                Text("RECENT ACTIVITY")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(.horizontal)
                                
                                ForEach(0..<3) { i in
                                    VoidCard(intensity: 40, cornerRadius: 16) {
                                        HStack {
                                            Circle().fill(Color.habyssPurple).frame(width: 32, height: 32)
                                            VStack(alignment: .leading) {
                                                Text("Alex completed 'Morning Run'").font(.subheadline).foregroundStyle(.white)
                                                Text("2 hours ago").font(.caption).foregroundStyle(Color.textTertiary)
                                            }
                                        }
                                        .padding()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                } else {
                    // REQUESTS
                    VStack {
                        ContentUnavailableView("No Pending Requests", systemImage: "person.badge.plus", description: Text("You're all caught up!"))
                            .foregroundStyle(Color.textSecondary)
                    }
                    .padding(.top, 40)
                    Spacer()
                }
            }
        }
    }
    
    func getRankEmoji(_ rank: Int) -> String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }
}

struct LeaderboardRow: View {
    var friend: CommunityScreen.Friend
    var index: Int
    var count: Int
    
    func getRankEmoji(_ rank: Int) -> String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(getRankEmoji(friend.rank))
                    .font(.title3)
                    .frame(width: 30)
                
                Circle()
                    .fill(Color.habyssNavy) // Placeholder
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(friend.name.prefix(1))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.habyssBlue)
                    )
                
                Text(friend.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(friend.name == "You" ? Color.habyssBlue : Color.textPrimary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(Color.habyssTeal)
                        .font(.caption)
                    Text("\(friend.streak)")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.habyssTeal)
                }
            }
            .padding(.vertical, 12)
            
            if index < count - 1 {
                Divider().background(Color.white.opacity(0.1))
            }
        }
    }
}
#Preview {
    CommunityScreen()
}
