//
//  Chat.swift
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
import UIKit

enum ChatRole {
    case user
    case aiModel
}

struct Media {
    let mimeType: String
    let data: Data
    let thumbnail: UIImage
    var overlayIconName: String {
        if mimeType.starts(with: "video") {
            return "video.circle.fill"
        }
        else if mimeType.starts(with: "image") {
            return "photo.circle.fill"
        }
        else if mimeType.contains("pdf") || mimeType.contains("text") {
            return "doc.circle.fill"
        }
        return ""
    }
}

struct ChatMessage: Identifiable, Equatable {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    let role: ChatRole
    var message: String
    let media: [Media]?
}
