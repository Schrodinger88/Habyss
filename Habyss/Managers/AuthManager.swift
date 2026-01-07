import Foundation
import Supabase
import Observation

@Observable
class AuthManager {
    // Singleton for easy access (or inject it)
    static let shared = AuthManager()
    
    var session: Session?
    var userProfile: UserProfile?
    
    private let supabase = SupabaseService.shared.client
    
    var isAuthenticated: Bool {
        return session != nil
    }
    
    var currentUserId: UUID? {
        return session?.user.id
    }
    
    init() {
        Task {
            await initializeSession()
        }
    }
    
    func initializeSession() async {
        do {
            self.session = try await supabase.auth.session
            if let userId = session?.user.id {
                await fetchProfile(userId: userId)
            }
        } catch {
            print("No active session")
        }
        
        // Listen for auth changes
        for await state in supabase.auth.authStateChanges {
            self.session = state.session
            if let userId = state.session?.user.id {
                await fetchProfile(userId: userId)
            } else {
                self.userProfile = nil
            }
        }
    }
    
    func fetchProfile(userId: UUID) async {
        do {
            let profile: UserProfile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            self.userProfile = profile
        } catch {
            print("Error fetching profile: \(error)")
        }
    }
    
    func signOut() async throws {
        try await supabase.auth.signOut()
    }
}
