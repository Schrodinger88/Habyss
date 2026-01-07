import SwiftUI

struct CreateItemSheet: View {
    @Binding var isPresented: Bool
    @State private var showHabitCreation = false
    // @State private var showGoalCreation = false // To be implemented
    
    var body: some View {
        ZStack {
            Color.habyssBlack.ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                Text("CREATE")
                    .font(.title2) // Lexend?
                    .fontWeight(.black)
                    .tracking(2)
                    .foregroundStyle(.white)
                
                Text("NEW ITEM")
                    .font(.caption)
                    .tracking(2)
                    .foregroundStyle(Color.textSecondary)
                    .offset(y: -24)
                
                // Buttons
                HStack(spacing: 20) {
                    // Create Habit
                    Button(action: {
                        showHabitCreation = true
                    }) {
                        CreateOptionCard(
                            icon: "repeat",
                            color: .habyssGreen,
                            title: "Habit",
                            subtitle: "Daily routine"
                        )
                    }
                    
                    // Create Goal
                    Button(action: {
                        // showGoalCreation = true
                    }) {
                        CreateOptionCard(
                            icon: "flag.fill",
                            color: .habyssPurple,
                            title: "Goal",
                            subtitle: "Big objective"
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .presentationDetents([.height(350)])
        .sheet(isPresented: $showHabitCreation) {
            HabitCreationView(isPresented: $showHabitCreation)
        }
    }
}

struct CreateOptionCard: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        VoidCard(intensity: 30, cornerRadius: 24) {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundStyle(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        }
    }
}
