import SwiftUI
import SwiftData

struct AIAgentView: View {
    @Binding var isPresented: Bool
    @State private var inputText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: UUID(), role: .assistant, content: "I'm ABYSS, your AI agent. I can manage your habits, change settings, navigate the app, and more. Try: 'Turn on notifications' or 'Enable bully mode'.", date: Date())
    ]
    @State private var isTyping = false
    
    // Mock Suggestions
    let suggestions = ["Turn on notifications", "Enable bully mode", "Create workout habit", "Show my streak"]
    
    var body: some View {
        ZStack {
            // Background with Blur and Glow
            Color.habyssBlack.ignoresSafeArea()
            
            // Glow Effect
            GeometryReader { geo in
                Circle()
                    .fill(LinearGradient(colors: [.habyssBlue.opacity(0.3), .habyssPurple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geo.size.width * 1.5, height: geo.size.width * 1.5)
                    .blur(radius: 60)
                    .offset(x: -geo.size.width * 0.2, y: -geo.size.width * 0.5)
            }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { isPresented = false }) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "xmark").font(.caption).foregroundStyle(.white))
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.caption)
                                .foregroundStyle(LinearGradient(colors: [Color.habyssBlue, Color.habyssPink], startPoint: .leading, endPoint: .trailing))
                            Text("HABYSS AI")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                        }
                        Text("Your personal assistant")
                            .font(.caption2)
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Empty spacer for balance
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // Chat Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                            }
                            
                            if isTyping {
                                HStack(spacing: 4) {
                                    ForEach(0..<3) { _ in
                                        Circle()
                                            .fill(Color.textSecondary)
                                            .frame(width: 6, height: 6)
                                    }
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12, corners: [.topRight, .bottomLeft, .bottomRight])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages) {
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Suggestions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: {
                                inputText = suggestion
                                sendMessage()
                            }) {
                                Text(suggestion)
                                    .font(.caption)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(20)
                                    .overlay(
                                        Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                // Input Area
                HStack(spacing: 12) {
                    HStack {
                        TextField("Ask me anything...", text: $inputText)
                            .submitLabel(.send)
                            .onSubmit(sendMessage)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "photo")
                            Image(systemName: "mic")
                        }
                        .foregroundStyle(Color.textSecondary)
                        .font(.caption)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    Button(action: sendMessage) {
                        Circle()
                            .fill(inputText.isEmpty ? Color.white.opacity(0.1) : Color.habyssBlue)
                            .frame(width: 44, height: 44)
                            .overlay(Image(systemName: "arrow.up").font(.headline).foregroundStyle(.white))
                    }
                    .disabled(inputText.isEmpty)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        // Add User Message
        let userMsg = ChatMessage(id: UUID(), role: .user, content: inputText, date: Date())
        messages.append(userMsg)
        
        let prompt = inputText
        inputText = ""
        isTyping = true
        
        // Mock AI Response delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            let response = generateMockResponse(for: prompt)
            let aiMsg = ChatMessage(id: UUID(), role: .assistant, content: response, date: Date())
            messages.append(aiMsg)
        }
    }
    
    func generateMockResponse(for input: String) -> String {
        // Simple heuristic mocks
        let lower = input.lowercased()
        if lower.contains("notification") {
            return "I've enabled notifications for you. You'll strictly be reminded at your set times."
        } else if lower.contains("bully") {
            return "Bully mode activated. Prepare for no mercy if you miss a habit. Don't disappoint me."
        } else if lower.contains("card") || lower.contains("habit") {
            return "Use natural language to create habits. For example: 'Read 20 pages every night'."
        } else {
            return "I am ABYSS. I am here to ensure you adhere to your protocol. What do you require?"
        }
    }
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let role: MessageRole
    let content: String
    let date: Date
}

enum MessageRole {
    case user
    case assistant
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .assistant {
                // Avatar
                 Circle()
                    .fill(LinearGradient(colors: [Color.habyssBlue, Color.habyssPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 28, height: 28)
                    .overlay(Image(systemName: "sparkles").font(.caption2).foregroundStyle(.white))
            } else {
                Spacer()
            }
            
            Text(message.content)
                .font(.body)
                .padding(14)
                .background(message.role == .user ? Color.habyssBlue : Color.white.opacity(0.08))
                .foregroundStyle(message.role == .user ? .white : Color.textPrimary)
                .cornerRadius(18)
                .clipShape(
                    .rect(
                        topLeadingRadius: 18,
                        bottomLeadingRadius: message.role == .user ? 18 : 4,
                        bottomTrailingRadius: message.role == .user ? 4 : 18,
                        topTrailingRadius: 18
                    )
                )
            
            if message.role == .user {
                // No avatar for user, strictly bubble
            } else {
                Spacer()
            }
        }
    }
}
