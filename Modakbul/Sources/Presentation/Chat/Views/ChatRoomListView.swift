//
//  ChatRoomListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import SwiftUI

typealias Item = (id: UUID, image: URL?, nickname: String, lastMessage: String, time: Date, unreadCount: Int)

struct ChatRoomListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    @State private var chatRooms: [Item] = [
        (UUID(), nil, "디자인 천재", "네 오늘 너무 유익했어요!", .now, 10),
        (UUID(), nil, "웹 개발 10년차", "좋아요!", .now, 1),
        (UUID(), nil, "똑똑똑한박사", "알겠습니다~감사합니다.", .now, 11)
    ]
    
    var body: some View {
        List(chatRooms, id: \.id) { item in
            Cell(item)
                .contentShape(.rect)
                .onTapGesture {
                    router.route(to: .chatView)
                }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
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
                        .font(.Modakbul.headline)
                    
                    Text(chatRoom.lastMessage)
                        .font(.Modakbul.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text(chatRoom.time.toString(by: .ahmm))
                        .font(.Modakbul.subheadline)
                    
                    Badge(count: chatRoom.unreadCount)
                }
            }
        }
    }
}
