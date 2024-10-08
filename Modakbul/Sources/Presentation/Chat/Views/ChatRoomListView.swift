//
//  ChatRoomListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import SwiftUI
import SwiftData

struct ChatRoomListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    // TODO: - 채팅방 목록 조회 API 연결 필요. 다만, HTTP Request임.
    @Query private var chatRooms: [ChatRoom]
    
    var body: some View {
        List(chatRooms) { chatRoom in
            // TODO: - 채팅이 새로 들어올때마다 시간순으로 정렬 필요
            Cell(chatRoom)
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
        let chatRoom: ChatRoom
        
        init(_ chatRoom: ChatRoom) {
            self.chatRoom = chatRoom
        }
        
        var body: some View {
            HStack {
                AsyncImageView(url: chatRoom.opponentuserImageURL)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(chatRoom.title)
                        .font(.Modakbul.headline)
                    
                    Text(chatRoom.messages.last?.content ?? "")
                        .font(.Modakbul.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text(chatRoom.messages.last?.sendTime.toString(by: .ahmm) ?? "")
                        .font(.Modakbul.subheadline)
                    
                    Badge(count: chatRoom.unreadMessagesCount)
                }
            }
        }
    }
}
