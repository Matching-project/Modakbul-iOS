//
//  ChatRoomListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import SwiftUI
import SwiftData

struct ChatRoomListView<Router: AppRouter>: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: ChatRoomListViewModel
    
    @Query private var chatRooms: [ChatRoom]
    
    init(_ viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(chatRooms) { chatRoom in
            // TODO: - 채팅이 새로 들어올때마다 시간순으로 정렬 필요
            Cell(chatRoom)
                .contentShape(.rect)
                .onTapGesture {
                    router.route(to: .chatView(chatRoom: chatRoom))
                }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .onReceive(viewModel.$configurations) { configurations in
            configurations.forEach { configuration in
                guard chatRooms.contains(where: { $0.id == configuration.id }) == false else { return }
                let newChatRoom = ChatRoom(configuration: configuration)
                modelContext.insert(newChatRoom)
            }
            
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }
        .onAppear {
            viewModel.readChatRooms(userId: Int64(userId))
        }
    }
    
    // TODO: 비로그인 상태에서 채팅방 목록 화면 진입 시 로그인뷰로 대신 라우팅
//    @ViewBuilder private func buildView() -> some View {
//        if userId == Constants.loggedOutUserId {
//            
//        } else {
//            
//        }
//    }
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
                    Text(chatRoom.title ?? "새로운 채팅방")
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
