import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String = "Traveler"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Username", text: $username)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}
