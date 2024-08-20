//
//  MultimodalChatView.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import SwiftUI
import PhotosUI

struct MultimodalChatView: View {
    @State private var textInput = ""
    @State private var chatService = ChatService()
    @State private var photoPickerItems = [PhotosPickerItem]()
    @State private var selectedMedia = [Media]()
    @State private var showAttachmentOptions = false
    @State private var showPhotoPicker = false
    @State private var showFilePicker = false
    @State private var showEmptyTextAlert = false
    @State private var loadingMedia = false
    
    var body: some View {
        VStack {
            // MARK: Logo
            Image(.geminiStarLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            // MARK: Chat message list
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatService.messages, id:\.self.id) { message in
                        // MARK: Chat message view
                        ChatMessageView(chatMessage: message)
                    }
                }
                .onChange(of: chatService.messages) {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: chatService.loadingResponse) {
                    scrollToBottom(proxy: proxy)
                }
            })
            
            // MARK: Image preview
            if selectedMedia.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10, content: {
                        ForEach(0..<selectedMedia.count, id: \.self) { index in
                            Image(uiImage: selectedMedia[index].thumbnail)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    })
                }
                .frame(height: 50)
                .padding(.bottom, 8)
            }
            
            // MARK: Input fields
            HStack {
                Button {
                    showAttachmentOptions.toggle()
                } label: {
                    if loadingMedia {
                        ProgressView()
                            .tint(Color.white)
                            .frame(width: 40)
                    } else {
                        Image(systemName: "paperclip")
                            .frame(width: 40, height: 25)
                    }
                }
                .disabled(chatService.loadingResponse)
                .confirmationDialog("What would you like to attach?",
                                    isPresented: $showAttachmentOptions,
                                    titleVisibility: .visible) {
                    Button("Images / Videos") {
                        showPhotoPicker.toggle()
                    }
                    Button("Documents") {
                        showFilePicker.toggle()
                    }
                }.photosPicker(isPresented: $showPhotoPicker,
                               selection: $photoPickerItems,
                               maxSelectionCount: 2,
                               matching: .any(of: [.images, .videos]))
                .onChange(of: photoPickerItems) { oldValue, newValue in
                    Task {
                        loadingMedia.toggle()
                        selectedMedia.removeAll()
                        for item in photoPickerItems {
                            do {
                                let (mimeType, data, thumbnail) = try await MediaService().processPhotoPickerItem(for: item)
                                selectedMedia.append(.init(mimeType: mimeType, data: data, thumbnail: thumbnail))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        loadingMedia.toggle()
                    }
                }
                .fileImporter(isPresented: $showFilePicker,
                              allowedContentTypes: [.text, .pdf],
                              allowsMultipleSelection: true) { result in
                    selectedMedia.removeAll()
                    loadingMedia.toggle()
                    
                    switch result {
                    case .success(let urls):
                        for url in urls {
                            do {
                                let (mimeType, data, thumbnail) = try MediaService().processDocumentItem(for: url)
                                selectedMedia.append(.init(mimeType: mimeType, data: data, thumbnail: thumbnail))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print("Failed to import file(s): \(error.localizedDescription)")
                    }
                    
                    loadingMedia.toggle()
                }
                
                TextField("Enter a message...", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                    .alert("Please enter a message", isPresented: $showEmptyTextAlert, actions: {})
                
                if chatService.loadingResponse {
                    ProgressView()
                        .tint(Color.white)
                        .frame(width: 30)
                } else {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .frame(width: 30)
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background {
            Color.black.ignoresSafeArea()
        }
    }
    
    private func sendMessage() {
        guard !textInput.isEmpty else {
            showEmptyTextAlert.toggle()
            return
        }
        Task {
            let chatMedia = selectedMedia
            selectedMedia.removeAll()
            await chatService.sendMessage(message: textInput, media: chatMedia)
            textInput = ""
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let recentMessage = chatService.messages.last else { return }
        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(recentMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    MultimodalChatView()
}
