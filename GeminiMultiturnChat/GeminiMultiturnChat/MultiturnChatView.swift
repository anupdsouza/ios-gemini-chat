//
//  MultiturnChatView.swift
//  GeminiMultiturnChat
//
//  Created by Anup D'Souza
//

import SwiftUI

struct MultiturnChatView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatService = ChatService()
    
    var body: some View {
        VStack {
            // MARK: Animating logo
            Image(.geminiLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(logoAnimating ? 0.5 : 1)
                .animation(.easeInOut, value: logoAnimating)
            
            // MARK: Chat message list
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatService.messages) { chatMessage in
                        // MARK: Chat message view
                        chatMessageView(chatMessage)
                    }
                }
                .onChange(of: chatService.messages) { _, _ in
                    guard let recentMessage = chatService.messages.last else { return }
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatService.loadingResponse) { _, newValue in
                    if newValue {
                        startLoadingAnimation()
                    } else {
                        stopLoadingAnimation()
                    }
                }
            })
            
            // MARK: Input fields
            HStack {
                TextField("Enter a message...", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.black)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background {
            // MARK: Background
            ZStack {
                Color.black
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: Chat message view
    @ViewBuilder func chatMessageView(_ message: ChatMessage) -> some View {
        ChatBubble(direction: message.role == .model ? .left : .right) {
            Text(message.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background(message.role == .model ? Color.blue : Color.green)
        }
    }
    
    // MARK: Fetch response
    func sendMessage() {
        chatService.sendMessage(textInput)
        textInput = ""
    }
    // MARK: Response loading animation
    func startLoadingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation() {
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    MultiturnChatView()
}
