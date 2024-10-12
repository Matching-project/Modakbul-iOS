//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI
import SwiftData

struct ChatView<Router: AppRouter>: View {
    @AppStorage(AppStorageKey.userId) private var userId = Constants.loggedOutUserId
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = String()
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ChatViewModel
    @FocusState private var isFocused: Bool
    
    @Bindable var chatRoom: ChatRoom
    
    init(
        _ chatViewModel: ChatViewModel,
        chatRoom: ChatRoom
    ) {
        chatViewModel.configureView(chatRoomId: chatRoom.id)
        self.vm = chatViewModel
        self.chatRoom = chatRoom
    }
    
    var body: some View {
        ZStack {
            chats
                .overlay(alignment: .topTrailing) {
                    Header(vm.locationName, vm.communityRecruitingContentTitle)
                }
        }
        .navigationModifier(title: "채팅방") {
            router.dismiss()
        }
        .task {
            vm.fetchOpponentUserProfile(userId: Int64(userId), opponentUserId: chatRoom.opponentUserId)
            vm.messages = chatRoom.messages
            vm.readChatingHistory(userId: Int64(userId), on: chatRoom.id, with: chatRoom.relatedCommunityRecruitingContentId)
            await vm.startChat(userId: Int64(userId), userNickname: userNickname)
        }
        .onDisappear {
            // TODO: - 화면 나가기 전에 vm 초기화같은 작업이 필요한지? 네
            vm.stopChat()
            chatRoom.messages = vm.messages
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // TODO: 기능 연결 필요
                Menu {
                    Button {
                        vm.block(userId: Int64(userId))
                    } label: {
                        Text("차단하기")
                    }
                    
                    Button {
                        // TODO: 신고하기 화면으로 이동할 방법 고민 좀
                    } label: {
                        Text("신고하기")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    private var chats: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(vm.messages) { message in
                        cell(message: message)
                    }
                }
            }
            .defaultScrollAnchor(.bottom)
            
            HStack {
                TextField("메세지를 입력해주세요", text: $vm.textOnTextField, axis: .vertical)
                    .automaticFunctionDisabled()
                    .roundedRectangleStyle(cornerRadius: 30, vertical: 10)
                    .focused($isFocused)
                    .lineLimit(5)
                
                Button {
                    vm.send(userId: Int64(userId), userNickname: userNickname)
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .rotationEffect(.degrees(45))
                }
            }
            .safeAreaPadding(.horizontal)
        }
        .onTapGesture {
            isFocused = false
        }
    }
    
    @ViewBuilder
    private func cell(message: ChatMessage) -> some View {
        let role = ChatRole(myUserId: Int64(userId), senderId: message.senderId)
        switch role {
        case .system:
            systemCell(message)
        case .me:
            myCell(message)
        case .opponentUser:
            opponentUserCell(message, vm.opponentUser)
        }
    }
    
    @ViewBuilder
    private func systemCell(_ message: ChatMessage) -> some View {
        Text(message.sendTime.toString(by: .yyyyMMddKorean))
            .padding(10)
            .font(.Modakbul.caption)
            .containerRelativeFrame(.horizontal)
    }
    
    @ViewBuilder
    private func myCell(_ message: ChatMessage) -> some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            VStack(alignment: .trailing, spacing: -3) {
                Text(message.unreadCount == 0 ? "" : message.unreadCount.description)
                    .foregroundStyle(.accent)
                
                Text(message.sendTime.toString(by: .HHmm))
                    .foregroundStyle(.gray)
            }
            
            Text(message.content)
                .padding(10)
                .foregroundStyle(.white)
                .background(.accent)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding(10)
    }
    
    @ViewBuilder
    private func opponentUserCell(_ message: ChatMessage, _ user: User?) -> some View {
        HStack(alignment: .top) {
            AsyncImageView(url: user?.imageURL)
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .onTapGesture {
                    if let id = user?.id {
                        router.route(to: .profileDetailView(opponentUserId: id))
                    }
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user?.nickname ?? "")
                    .bold()
                
                // 채팅방 위치를 기준으로 읽음 처리 및 시간이 표시되어야 합니다.
                HStack(alignment: .bottom) {
                    Text(message.content)
                        .padding(10)
                        .foregroundStyle(.white)
                        .background(.secondary)
                        .clipShape(.rect(cornerRadius: 10))
                    
                    VStack(alignment: .leading, spacing: -3) {
                        Text(message.unreadCount == 0 ? "" : message.unreadCount.description)
                            .foregroundStyle(.accent)
                        
                        Text(message.sendTime.toString(by: .HHmm))
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            Spacer()
        }
        .padding(10)
    }
}

extension ChatView {
    /// 모집글 정보를 보여주는 뷰입니다.
    struct Header: View {
        @State private var topExpanded: Bool = false
        @Environment(\.colorScheme) private var colorScheme
        
        private let place: String
        private let communityRecruitingContentTitle: String
        
        init(
            _ place: String,
            _ communityRecruitingContentTitle: String
        ) {
            self.place = place
            self.communityRecruitingContentTitle = communityRecruitingContentTitle
        }
        
        var body: some View {
            if topExpanded {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(communityRecruitingContentTitle)
                            .bold()
                        
                        Text(place)
                            .font(.Modakbul.caption)
                            .bold()
                    }
                    .foregroundStyle(.accent)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            topExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .frame(width: 20, height: 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.accent, lineWidth: 2)
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(colorScheme == .dark ? .black.opacity(0.8) : .white.opacity(0.8))
                        .shadow(radius: 2, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            } else {
                Button {
                    withAnimation {
                        topExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(colorScheme == .dark ? .black : .white))
                }
                .padding([.top, .trailing], 10)
            }
        }
    }
}
