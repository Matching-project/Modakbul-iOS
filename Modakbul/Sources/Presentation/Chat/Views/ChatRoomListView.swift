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
                viewModel.configurations.removeAll()
                if userId != Constants.loggedOutUserId {
                    viewModel.readChatRooms(userId: Int64(userId))
                }
            }
    }
    
    private func deleteSwipeAction(for chatRoom: ChatRoom) -> some View {
        Button(role: .destructive) {
            viewModel.deleteChatRoom(chatRoom.id, on: Int64(userId))
        } label: {
            Label("삭제하기", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private func buildView() -> some View {
        if viewModel.configurations.isEmpty {
            ContentUnavailableView("채팅방이 없습니다.", systemImage: "questionmark", description: Text("아무도 없어요..."))
        } else {
            List(chatRooms) { chatRoom in
                Cell(chatRoom)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.routeToChatRoom(userId: Int64(userId), chatRoom: chatRoom) {
                            router.route(to: .chatView(chatRoom: chatRoom))
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteSwipeAction(for: chatRoom)
                    }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .onReceive(viewModel.$configurations) { configurations in
                configurations.forEach { configuration in
                    guard let index = chatRooms.firstIndex(where: { $0.id == configuration.id }) else {
                        let newChatRoom = ChatRoom(configuration: configuration)
                        modelContext.insert(newChatRoom)
                        return
                    }
                    
                    chatRooms[index].update(with: configuration)
                }
                
                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }
            }
            .onReceive(viewModel.deletionSubject) { deletedChatRoomId in
                do {
                    try modelContext.delete(model: ChatRoom.self, where: #Predicate<ChatRoom>{ $0.id == deletedChatRoomId })
                } catch {
                    print(error)
                }
            }
            .onChange(of: viewModel.presentedAlert) { _, newValue in
                guard let alert = newValue else { return }
                router.alert(for: alert, actions: [
                    .defaultAction("확인", action: {
                        viewModel.presentedAlert = nil
                    })
                ])
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
                    url: chatRoom.opponentUserImageURL,
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
                    if let lastSendTime = chatRoom.messages.last?.sendTime {
                        AsyncDateView(date: lastSendTime, format: .ahmm, font: .Modakbul.subheadline)
                    }
                    
                    Badge(count: chatRoom.unreadMessagesCount)
                }
            }
        }
    }
}
