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
    
    @Query private var chatRooms: [ChatRoom]
    
    var body: some View {
        List(chatRooms) { chatRoom in
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
