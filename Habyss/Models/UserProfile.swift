import Foundation

struct UserProfile: Codable, Identifiable {
    let id: UUID
    let username: String?
    let email: String?
    let avatarUrl: String?
    let pushToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case avatarUrl = "avatar_url"
        case pushToken = "push_token"
    }
}
