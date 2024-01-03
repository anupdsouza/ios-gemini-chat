//
//  Chat.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza
//

import Foundation

enum ChatRole {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
    var images: [Data]?
}
