//
//  ChatService.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

@Observable
class ChatService {
    private var proModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    private var proVisionModel = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    private(set) var messages = [ChatMessage]()
    private(set) var loadingResponse = false
    
    func sendMessage(message: String, imageData: [Data]) async {
        
        loadingResponse = true
        
        // MARK: add user's message & a placeholder ai model message to the list
        messages.append(.init(role: .user, message: message, images: imageData))
        messages.append(.init(role: .model, message: "", images: nil))
        
        do {
            let chatModel = imageData.isEmpty ? proModel : proVisionModel
            
            var images = [any ThrowingPartsRepresentable]()
            for data in imageData {
                // compressing the data as max size allowed for images is approx 4MB
                if let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.1) {
                    images.append(ModelContent.Part.jpeg(compressedData))
                }
            }
            
            // MARK: Request and stream the response
            let outputStream = chatModel.generateContentStream(message, images)
            for try await chunk in outputStream {
                guard let text = chunk.text else {
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
            messages.append(.init(role: .model, message: "Something went wrong. Please try again."))
            print(error.localizedDescription)
        }
    }
}
