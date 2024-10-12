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
        buildView()
            .onAppear {
                if userId != Constants.loggedOutUserId {
                    viewModel.readChatRooms(userId: Int64(userId))
                }
            }
    }
    
    private func deleteSwipeAction(for chatRoom: ChatRoom) -> some View {
        Button(role: .destructive) {
            viewModel.deleteChatRoom(chatRoom, on: Int64(userId), by: modelContext)
        } label: {
            Label("삭제하기", systemImage: "trash")
        }
    }
    
    @ViewBuilder private func buildView() -> some View {
        if userId == Constants.loggedOutUserId {
            ContentUnavailableView {
                VStack {
                    Spacer()
                    Text("로그인 해야 볼 수 있어요.")
                    Spacer()
                    Button {
                        router.route(to: .loginView)
                    } label: {
                        Text("로그인하기")
                    }
                }
            }
        } else {
            List(chatRooms) { chatRoom in
                Cell(chatRoom)
                    .contentShape(.rect)
                    .onTapGesture {
                        router.route(to: .chatView(chatRoom: chatRoom))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteSwipeAction(for: chatRoom)
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
        }
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
                AsyncImageView(
                    url: chatRoom.opponentuserImageURL,
                    contentMode: .fill,
                    clipShape: .circle
                )
                
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
