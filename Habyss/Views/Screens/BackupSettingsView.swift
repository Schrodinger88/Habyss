import SwiftUI

struct BackupSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color.textPrimary)
                    }
                    Spacer()
                    Text("Backup & Storage")
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Color.clear.frame(width: 20) // Balance
                }
                .padding()
                .background(Color.habyssBlack)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Status Card
                        VoidCard(intensity: 20, cornerRadius: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Last Backup")
                                        .font(.headline)
                                        .foregroundStyle(Color.textPrimary)
                                    Text("Never")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "cloud") // Checkmark implies success, cloud implies status
                                    .font(.title2)
                                    .foregroundStyle(Color.habyssTeal)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.caption2)
                                            .offset(x: 1, y: 1)
                                            .foregroundStyle(Color.habyssTeal)
                                    )
                            }
                            .padding(20)
                        }
                        
                        // Backup Button
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "cloud.fill")
                                Text("Backup Now")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(colors: [Color(hex: "5B61F4"), Color(hex: "A855F7")], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(16)
                        }
                        
                        // Actions
                        VoidCard(intensity: 20, cornerRadius: 16) {
                            VStack(spacing: 0) {
                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "cloud.and.arrow.down")
                                            .foregroundStyle(Color.textSecondary)
                                        Text("Restore from Backup")
                                            .foregroundStyle(Color.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color.textTertiary)
                                    }
                                    .padding()
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .foregroundStyle(Color.textSecondary)
                                        Text("Clear Cache")
                                            .foregroundStyle(Color.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color.textTertiary)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
