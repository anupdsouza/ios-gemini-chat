//
//  ChatMessageView.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza on 20/08/24.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import SwiftUI

struct ChatMessageView: View {
    private let mediaHeight = 150.0
    let chatMessage: ChatMessage
    var body: some View {
        VStack {
            // MARK: Chat media
            if let media = chatMessage.media, media.isEmpty == false {
                GeometryReader(content: { geometry in
                    ScrollView(.horizontal) {
                        HStack(spacing: 10, content: {
                            Spacer()
                                .frame(width: spacerWidth(for: media, geometry: geometry))
                            
                            ForEach(0..<media.count, id: \.self) { index in
                                let mediaItem = media[index]
                                Image(uiImage: mediaItem.thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: mediaHeight)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(alignment: .topLeading) {
                                        Image(systemName: mediaItem.overlayIconName)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .shadow(color: .black, radius: 10)
                                            .padding(8)
                                    }
                            }
                        })
                    }
                })
                .frame(height: 150)
            }
            
            // MARK: Chat bubble
            ChatBubble(direction: chatMessage.role == .aiModel ? .left : .right) {
                Text(chatMessage.message)
                    .font(.title3)
                    .padding(.all, 20)
                    .foregroundStyle(.white)
                    .background(chatMessage.role == .aiModel ? Color.blue : Color.green)
            }
        }
        .id(chatMessage.id)
    }
    
    private func spacerWidth(for media: [Media], geometry: GeometryProxy) -> CGFloat {
        var totalWidth: CGFloat = 0
        for mediaItem in media {
            let scaledWidth = mediaItem.thumbnail.size.width * (mediaHeight/mediaItem.thumbnail.size.height)
            totalWidth += scaledWidth + 20
        }
        
        return totalWidth < geometry.size.width ? geometry.size.width - totalWidth : 0
    }
}

#Preview {
    ChatMessageView(chatMessage: .init(role: .user, message: "", media: nil))
}
