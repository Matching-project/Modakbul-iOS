//
//  ChatRoomListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import SwiftUI

typealias Item = (id: UUID, image: URL?, nickname: String, lastMessage: String, time: Date, unreadCount: Int)

struct ChatRoomListView: View {
    @State private var chatRooms: [Item] = [Item](repeating: (UUID(), nil, "디자인 천재", "네 오늘 너무 유익했어요!", .now, 30), count: 5)
    
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
                AsyncDynamicSizingImageView(url: chatRoom.image, width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(chatRoom.nickname)
                        .font(.headline)
                    
                    Text(chatRoom.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(chatRoom.time.toString(by: .ahmm))
                        .font(.subheadline)
                    
                    Text("\(chatRoom.unreadCount)")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(2)
                        .background(
                            Capsule()
                                .foregroundStyle(.accent)
                        )
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
