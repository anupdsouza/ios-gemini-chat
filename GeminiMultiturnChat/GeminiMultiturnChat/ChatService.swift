//
//  ChatService.swift
//  GeminiChat
//
//  Created by Anup D'Souza
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

enum ChatRole {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
}

@Observable
class ChatService {
    private var chat: Chat?
    private(set) var messages = [ChatMessage]()
    private(set) var loadingResponse = false
    
    func sendMessage(_ message: String) {
        loadingResponse = true
        
        if (chat == nil) {
            let history: [ModelContent] = messages.map { ModelContent(role: $0.role == .user ? "user" : "model", parts: $0.message)}
            chat = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default).startChat(history: history)
        }
        
        // MARK: Add user's message to the list
        messages.append(.init(role: .user, message: message))
        
        Task {
            do {
                let response = try await chat?.sendMessage(message)
                
                loadingResponse = false
                
                guard let text = response?.text else {
                    messages.append(.init(role: .model, message: "Something went wrong, please try again."))
                    return
                }
                
                messages.append(.init(role: .model, message: text))
            }
            catch {
                loadingResponse = false
                messages.append(.init(role: .model, message: "Something went wrong, please try again."))
            }
        }
    }
}

