//
//  ChatRoomListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import SwiftUI

typealias Item = (id: UUID, image: URL?, nickname: String, lastMessage: String, time: Date, unreadCount: Int)

struct ChatRoomListView: View {
    @State private var chatRooms: [Item] = [
        (UUID(), nil, "디자인 천재", "네 오늘 너무 유익했어요!", .now, 10),
        (UUID(), nil, "웹 개발 10년차", "좋아요!", .now, 1),
        (UUID(), nil, "똑똑똑한박사", "알겠습니다~감사합니다.", .now, 11)
    ]
    
    var body: some View {
        List(chatRooms, id: \.id) { item in
            Cell(item)
        }
        .listStyle(.plain)
        .navigationTitle("채팅")
    }
}

extension ChatRoomListView {
    struct Cell: View {
        let chatRoom: Item
        
        init(_ item: Item) {
            self.chatRoom = item
        }
        
        var body: some View {
            HStack {
                AsyncImageView(url: chatRoom.image)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(chatRoom.nickname)
                        .font(.headline)
                    
                    Text(chatRoom.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text(chatRoom.time.toString(by: .ahmm))
                        .font(.subheadline)
                    
                    Badge(count: chatRoom.unreadCount)
                }
            }
        }
    }
}

struct ChatRoomListView_Preview: PreviewProvider {
    static var previews: some View {
        ChatRoomListView()
    }
}