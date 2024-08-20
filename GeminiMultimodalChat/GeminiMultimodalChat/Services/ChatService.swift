//
//  ChatService.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

@Observable
class ChatService {
    private var model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
    private(set) var messages = [ChatMessage]()
    private(set) var loadingResponse = false
    
    @MainActor
    func sendMessage(message: String, media: [Media]) async {
        do {
            loadingResponse = true
            
            messages.append(.init(role: .user, message: message, media: media))
            messages.append(.init(role: .aiModel, message: "", media: nil))
            
            var chatMedia = [any ThrowingPartsRepresentable]()
            for mediaItem in media {
                if mediaItem.mimeType == "video/mp4" || mediaItem.mimeType == "text/plain" || mediaItem.mimeType == "application/pdf" {
                    chatMedia.append(ModelContent.Part.data(mimetype: mediaItem.mimeType, mediaItem.data))
                }
                else {
                    chatMedia.append(ModelContent.Part.jpeg(mediaItem.data))
                }
            }
            
            let responseStream = model.generateContentStream(message, chatMedia)
            for try await response in responseStream {
                guard let text = response.text else {
                    return
                }
                
                let lastChatMessageIndex = messages.count - 1
                messages[lastChatMessageIndex].message += text
            }
            loadingResponse = false
        }
        catch {
            loadingResponse = false
            messages.removeLast()
            messages.append(.init(role: .aiModel, message: "Something went wrong, please try again", media: nil))
            print(error.localizedDescription)
        }
    }
}
