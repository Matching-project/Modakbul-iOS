//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI
import Combine
import SwiftData

final class ChatViewModel: ObservableObject {
    @Published var communityRecruitingContentTitle: String = ""
    @Published var locationName: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var textOnTextField: String = ""
    
    private var chatRoomId: Int64 = Constants.temporalId
    
    private let chatUseCase: ChatUseCase
    private var previousDate: Date?
    
    private var cancellables = Set<AnyCancellable>()
    private let chatHistorySubject = PassthroughSubject<ChatHistory, Never>()
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        subscribe()
    }
    
    private func subscribe() {
        chatHistorySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatHistory in
                guard let self = self else { return }
                
                communityRecruitingContentTitle = chatHistory.communityRecruitingContentTitle
                locationName = chatHistory.locationName
                // TODO: - 채팅내역 불러오기 API 변경 필요
//                let newMessages = chatHistory.messages.map { (content, timestamp) in
//                    return ChatMessage(
//                        chatRoomId: self.chatRoomId,
//                        senderId: <#T##Int64#>,
//                        senderNickname: <#T##String#>,
//                        content: content,
//                        sendTime: timestamp,
//                        unreadCount: <#T##Int#>
//                    )
//                }
                
            }
            .store(in: &cancellables)
        
        $messages
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.compareNewMessages()
                }
            }
            .store(in: &cancellables)
    }
    
    func configureView(chatRoomId: Int64) {
        self.chatRoomId = chatRoomId
    }
    
    func readChatingHistory(userId: Int64,
                            on chatRoomId: Int64,
                            with communityRecruitingContentId: Int64
    ) {
        Task {
            do {
                let chatHistory = try await chatUseCase.readChatingHistory(userId: userId,
                                                                           on: chatRoomId,
                                                                           with: communityRecruitingContentId)
                chatHistorySubject.send(chatHistory)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    private func compareNewMessages() {
        guard let currentMessage = messages.last else { return }
        messages.removeLast()
        
        guard let lastMessage = messages.last else { return }
        compare(latestMessage: lastMessage, currentMessage: currentMessage)
        
        messages.append(currentMessage)
    }
    
    @MainActor
    func compare(latestMessage: ChatMessage, currentMessage: ChatMessage) {
        let latestMessage = Calendar.current.startOfDay(for: latestMessage.sendTime)
        let currentMessageDate = Calendar.current.startOfDay(for: currentMessage.sendTime)
        
        // TODO: - senderId: -1이면 시스템 메세지로 취급하고 시간을 알려주는 용도로 사용할지?
        if latestMessage != currentMessageDate {
            //            messages.append(ChatMessage(chatRoomId: currentMessage.chatRoomId, senderId: -1, senderNickname: "", content: "", sendTime: currentMessage.sendTime, readCount: 0))
        }
    }
}

// MARK: Interfaces for ChatUseCase
extension ChatViewModel {
    func startChat(userId: Int64, userNickname nickname: String) async {
        let stream = AsyncThrowingStream<ChatMessage, any Error> { continuation in
            Task {
                do {
                    try await chatUseCase.startChat(userId: userId, userNickname: nickname, on: chatRoomId, continuation)
                } catch {
                    print(error)
                }
            }
        }
        
        do {
            for try await message in stream {
                messages.append(message)
            }
        } catch {
            print(error)
        }
    }
    
    func stopChat() {
        chatUseCase.stopChat(on: chatRoomId)
    }
    
    func send(userId: Int64, userNickname nickname: String) {
        guard textOnTextField.isEmpty == false else { return }
        
        let chatMessage = ChatMessage(
            chatRoomId: chatRoomId,
            senderId: userId,
            senderNickname: nickname,
            content: textOnTextField,
            sendTime: .now,
            unreadCount: 1
        )
        
        // TODO: 전송 실패 했을 경우 에러핸들링 필요
        try? chatUseCase.send(message: chatMessage)
    }
}

struct ChatView<Router: AppRouter>: View {
    @AppStorage(AppStorageKey.userId) private var userId = Constants.loggedOutUserId
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = String()
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ChatViewModel
    @FocusState private var isFocused: Bool
    
    init(
        _ chatViewModel: ChatViewModel,
        chatRoomId: Int64
    ) {
        chatViewModel.configureView(chatRoomId: chatRoomId)
        self.vm = chatViewModel
        
        let predicate = #Predicate<ChatRoom> { $0.id == chatRoomId }
        //        _chatRoom = Query(filter: predicate)
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
            await vm.startChat(userId: Int64(userId), userNickname: userNickname)
        }
        .onDisappear {
            // TODO: - 화면 나가기 전에 vm 초기화같은 작업이 필요한지? 네
            vm.stopChat()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // TODO: 기능 연결 필요
                Menu {
                    Button {
                        
                    } label: {
                        Text("차단하기")
                    }
                    
                    Button {
                        
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
            myCell(message)
            //            opponentUserCell(message, opponentUser)
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
    private func opponentUserCell(_ message: ChatMessage, _ user: User) -> some View {
        HStack(alignment: .top) {
            AsyncImageView(url: user.imageURL)
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .onTapGesture {
                    router.route(to: .profileDetailView(opponentUserId: user.id))
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.nickname)
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

struct ChatView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .chatView(chatRoomId: 0))
        }
    }
}
