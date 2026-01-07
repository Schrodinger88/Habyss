import Foundation
import CloudKit
import Observation

@Observable
class CloudKitSocialManager {
    static let shared = CloudKitSocialManager()
    
    private let container = CKContainer.default()
    private var publicDB: CKDatabase { container.publicCloudDatabase }
    
    var friends: [String] = [] // Placeholders for now
    
    init() {}
    
    // MARK: - User Discovery
    
    func searchUsers(byEmail email: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: "UserProfile", predicate: predicate)
        
        let (results, _) = try await publicDB.records(matching: query)
        
        return results.compactMap { try? $0.1.get() }
    }
    
    // MARK: - Friend Requests
    // Note: In a real CloudKit app, you'd use CKShare for direct sharing or a custom "FriendRequest" record type in the public DB.
    
    func sendFriendRequest(to userRecordName: String) async throws {
        let record = CKRecord(recordType: "FriendRequest")
        record["fromUser"] = try await container.userRecordID().recordName
        record["toUser"] = userRecordName
        record["status"] = "pending"
        
        try await publicDB.save(record)
    }
    
    func fetchIncomingRequests() async throws -> [CKRecord] {
        let myRecordID = try await container.userRecordID().recordName
        let predicate = NSPredicate(format: "toUser == %@ AND status == 'pending'", myRecordID)
        let query = CKQuery(recordType: "FriendRequest", predicate: predicate)
        
        let (results, _) = try await publicDB.records(matching: query)
        return results.compactMap { try? $0.1.get() }
    }
}
