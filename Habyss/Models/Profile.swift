import Foundation
import SwiftData

@Model
final class Profile {
    var id: String // CloudKit Record Name
    var username: String
    var email: String?
    var avatarUrl: String?
    var bio: String?
    
    init(id: String, username: String, email: String? = nil, avatarUrl: String? = nil, bio: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.avatarUrl = avatarUrl
        self.bio = bio
    }
}
