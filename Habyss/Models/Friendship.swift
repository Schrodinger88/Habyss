import Foundation

struct Friend: Codable, Identifiable {
    let id: UUID
    let username: String
    let email: String?
    let avatarUrl: String?
    let bio: String?
    let age: Int?
    let gender: String?
    
    // Stats (computed/joined)
    var currentStreak: Int = 0
    var todayCompletion: Int = 0
}

struct FriendRequest: Codable, Identifiable {
    let id: UUID
    let fromUserId: UUID
    let fromUsername: String?
    let fromAvatarUrl: String?
    let createdAt: Date
    let status: RequestStatus
    
    enum RequestStatus: String, Codable {
        case pending, accepted, declined
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "from_user_id"
        case fromUsername // Usually joined, might need custom decoding if flattening
        case fromAvatarUrl
        case createdAt = "created_at"
        case status
    }
}
