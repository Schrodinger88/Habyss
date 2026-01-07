import SwiftUI

struct AppearanceSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Mock State
    @State private var selectedTheme: String = "Habyss"
    @State private var selectedAccent: Color = .habyssBlue
    @State private var selectedCardSize: String = "Normal"
    
    let themes = [
        ("Light", "Bright and clean", "sun.max.fill", Color.white, Color.black),
        ("Habyss", "Signature dark mode", "moon.fill", Color.habyssBlack, Color.habyssBlue),
        ("True Dark", "OLED black", "circle.lefthalf.filled", Color.black, Color.gray)
    ]
    
    let accents: [Color] = [
        .habyssBlue, .blue, .cyan, .orange, .teal,
        .habyssPink, .red, .mint, .indigo, .habyssCoral,
        .green, .yellow, .purple
    ]
    
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
                    Text("Appearance")
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding()
                .background(Color.habyssBlack)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Theme Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("THEME")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textTertiary)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(themes, id: \.0) { theme in
                                    Button(action: { selectedTheme = theme.0 }) {
                                        VoidCard(intensity: selectedTheme == theme.0 ? 40 : 20, cornerRadius: 16) {
                                            HStack(spacing: 16) {
                                                Image(systemName: theme.2)
                                                    .font(.title3)
                                                    .foregroundStyle(theme.4)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(theme.0)
                                                        .font(.body)
                                                        .fontWeight(.medium)
                                                        .foregroundStyle(Color.textPrimary)
                                                    Text(theme.1)
                                                        .font(.caption)
                                                        .foregroundStyle(Color.textSecondary)
                                                }
                                                
                                                Spacer()
                                                
                                                if selectedTheme == theme.0 {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundStyle(Color.habyssTeal)
                                                }
                                            }
                                            .padding(16)
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(selectedTheme == theme.0 ? Color.habyssBlue : Color.clear, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Accent Color
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ACCENT COLOR")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textTertiary)
                                .padding(.horizontal)
                            
                            Text("Customize buttons, icons, and highlights")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 5), spacing: 16) {
                                ForEach(accents, id: \.self) { color in
                                    Button(action: { selectedAccent = color }) {
                                        Circle()
                                            .fill(color)
                                            .frame(height: 44)
                                            .overlay(
                                                Image(systemName: "checkmark")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(.white)
                                                    .opacity(selectedAccent == color ? 1 : 0)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: selectedAccent == color ? 2 : 0)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Card Size
                        VStack(alignment: .leading, spacing: 16) {
                            Text("CARD SIZE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textTertiary)
                                .padding(.horizontal)
                                
                            // ... Just text ...
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}
