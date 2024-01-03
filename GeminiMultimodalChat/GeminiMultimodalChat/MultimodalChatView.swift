//
//  MultimodalChatView.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza
//

import SwiftUI
import PhotosUI

struct MultimodalChatView: View {
    @State private var textInput = ""
    @State private var chatService = ChatService()
    @State private var photoPickerItems = [PhotosPickerItem]()
    @State private var selectedPhotoData = [Data]()
    
    var body: some View {
        VStack {
            // MARK: Logo
            Image(.geminiLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            // MARK: Chat message list
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatService.messages) { chatMessage in
                        // MARK: Chat message view
                        chatMessageView(chatMessage)
                    }
                }
                .onChange(of: chatService.messages) {
                    guard let recentMessage = chatService.messages.last else { return }
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
            })
            
            // MARK: Image preview
            if selectedPhotoData.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10, content: {
                        ForEach(0..<selectedPhotoData.count, id: \.self) { index in
                            Image(uiImage: UIImage(data: selectedPhotoData[index])!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    })
                }
                .frame(height: 50)
            }
            
            // MARK: Input fields
            HStack {
                PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 3, matching: .images) {
                    Image(systemName: "photo.stack.fill")
                        .frame(width: 40, height: 25)
                }
                .onChange(of: photoPickerItems) {
                    Task {
                        selectedPhotoData.removeAll()
                        for item in photoPickerItems {
                            if let imageData = try await item.loadTransferable(type: Data.self) {
                                selectedPhotoData.append(imageData)
                            }
                        }
                    }
                }
                
                TextField("Enter a message...", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                
                if chatService.loadingResponse {
                    // MARK: Loading indicator
                    ProgressView()
                        .tint(Color.white)
                        .frame(width: 30)
                } else {
                    // MARK: Send button
                    Button(action: sendMessage, label: {
                        Image(systemName: "paperplane.fill")
                    })
                    .frame(width: 30)
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
    @ViewBuilder private func chatMessageView(_ message: ChatMessage) -> some View {
        // MARK: Chat image dislay
        if let images = message.images, images.isEmpty == false {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10, content: {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: UIImage(data: images[index])!)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .containerRelativeFrame(.horizontal)
                    }
                })
                .scrollTargetLayout()
            }
            .frame(height: 150)
        }
        
        // MARK: Chat message bubble
        ChatBubble(direction: message.role == .model ? .left : .right) {
            Text(message.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background(message.role == .model ? Color.blue : Color.green)
        }
    }
    
    // MARK: Fetch response
    private func sendMessage() {
        Task {
            await chatService.sendMessage(message: textInput, imageData: selectedPhotoData)
            selectedPhotoData.removeAll()
            textInput = ""
        }
    }
}

#Preview {
    MultimodalChatView()
}
