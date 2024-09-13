//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 0, senderNickname: "디자인 천재", content: "안녕하세요!", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: -1, senderNickname: "", content: "", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))!, readCount: 0),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕하사시부리", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "안녕하다고", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 2),
        ChatMessage(chatRoomId: 0, senderId: -0, senderNickname: "디자인 천재", content: "삼성\n엘지\n테슬라", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "테스트\n테스트\n테스트\n테스트라이크~", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: -0, senderNickname: "디자인 천재", content: "이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 13))!, readCount: 1),
        ChatMessage(chatRoomId: 0, senderId: 10, senderNickname: "디자인 천재", content: "이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요이거어디까지길어지는거에요", sendTime: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 13))!, readCount: 1),
    ]
    @Published var textOnTextField: String = ""
    private var previousDate: Date?
    
    //    init() {
    //        $messages
    //            .sink { [weak self] _ in
    //                Task { [weak self] in
    //                    await self?.compareNewMessages()
    //                }
    //            }
    //            .store(in: &cancellables)
    //    }
    
    //    private var cancellables = Set<AnyCancellable>()
    //
    //    @MainActor
    //    private func compareNewMessages() {
    //        guard let currentMessage = messages.last else { return }
    //        messages.removeLast()
    //
    //        guard let lastMessage = messages.last else { return }
    //        compare(latestMessage: lastMessage, currentMessage: currentMessage)
    //
    //        messages.append(currentMessage)
    //    }
    //
    //    @MainActor
    //    func compare(latestMessage: ChatMessage, currentMessage: ChatMessage) {
    //        let latestMessage = Calendar.current.startOfDay(for: latestMessage.sendTime)
    //        let currentMessageDate = Calendar.current.startOfDay(for: currentMessage.sendTime)
    //
    //        // TODO: - senderId: -1이면 시스템 메세지로 취급하고 시간을 알려주는 용도로 사용할지?
    //        if latestMessage != currentMessageDate {
    //            messages.append(ChatMessage(chatRoomId: currentMessage.chatRoomId, senderId: -1, senderNickname: "", content: "", sendTime: currentMessage.sendTime, readCount: 0))
    //        }
    //    }
}

struct ChatView<Router: AppRouter>: View {
    @FocusState private var isFocused: Bool
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ChatViewModel
    
    private let place: Place
    private let opponentUser: User
    private let communityRecruitingContent: CommunityRecruitingContent
    
    init(_ chatViewModel: ChatViewModel,
         place: Place = Place(location: Location(name: "스타벅스 성수역점", address: "루몰")),
         opponentUser: User = User(id: 0, name: "디자인", nickname: "디자인 천재", gender: .female, job: .collegeStudent, isGenderVisible: true, birth: .now, imageURL: nil),
         communityRecruitingContent: CommunityRecruitingContent = CommunityRecruitingContent(title: "UI/UX 디자인 카페모임", content: "스벅", community: Community(routine: .daily, category: .coding, participants: [], participantsLimit: 10, meetingDate: "몰루", startTime: "10시", endTime: "20시"))
    ) {
        self.vm = chatViewModel
        self.place = place
        self.opponentUser = opponentUser
        self.communityRecruitingContent = communityRecruitingContent
    }
    
    var body: some View {
        VStack {
            Chat(vm, isFocused: $isFocused, opponentUser: opponentUser)
            
            Footer(isFocused: $isFocused, textOnTextField: $vm.textOnTextField)
        }
        .overlay(alignment: .topTrailing) {
            Header(place: place, communityRecruitingContent: communityRecruitingContent)
        }
        .navigationModifier(title: opponentUser.nickname) {
            // TODO: - 화면 나가기 전에 vm 초기화같은 작업이 필요한지?
            router.dismiss()
        }
    }
}

extension ChatView {
    /// 모집글 정보를 보여주는 뷰입니다.
    struct Header: View {
        @State private var topExpanded: Bool = false
        @Environment(\.colorScheme) private var colorScheme
        
        private let place: Place
        private let communityRecruitingContent: CommunityRecruitingContent
        
        init(place: Place, communityRecruitingContent: CommunityRecruitingContent) {
            self.place = place
            self.communityRecruitingContent = communityRecruitingContent
        }
        
        var body: some View {
            if topExpanded {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(communityRecruitingContent.title)
                            .bold()
                        
                        Text(place.location.name)
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
    
    /// 채팅 내용을 나타내는 뷰입니다.
    struct Chat: View {
        @ObservedObject private var vm: ChatViewModel
        private var isFocused: FocusState<Bool>.Binding
        //        @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
        
        // TODO: - 임시로 사용하는 유저 아이디
        private var userId = 10
        
        private let opponentUser: User
        
        init(_ vm: ChatViewModel, isFocused: FocusState<Bool>.Binding, opponentUser: User) {
            self.vm = vm
            self.isFocused = isFocused
            self.opponentUser = opponentUser
        }
        
        var body: some View {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(vm.messages) { message in
                        cell(message: message)
                            .padding(.horizontal, 10)
                    }
                }
                .scrollTargetLayout()
            }
            .defaultScrollAnchor(.bottom)
            .onTapGesture {
                isFocused.wrappedValue = false
            }
        
            // TODO: - 키보드를 통해 값이 입력되면 화면 맨 아래로 이동하게끔 해야함
        }
        
        @ViewBuilder
        private func cell(message: ChatMessage) -> some View {
            let role = ChatRole(myUserId: Int64(userId), senderId: message.senderId)
            switch role {
            case .system:
                SystemCell(message: message)
            case .me:
                MyCell(message: message)
            case .opponentUser:
                OpponentUserCell(message: message, user: opponentUser)
            }
        }
    }
    
    struct SystemCell: View {
        private let message: ChatMessage
        
        init(message: ChatMessage) {
            self.message = message
        }
        
        var body: some View {
            Text(message.sendTime.toString(by: .yyyyMMddKorean))
                .font(.Modakbul.caption)
                .containerRelativeFrame(.horizontal)
        }
    }
    
    struct MyCell: View {
        private let message: ChatMessage
        
        init(message: ChatMessage) {
            self.message = message
        }
        
        var body: some View {
            HStack(alignment: .bottom) {
                VStack(alignment: .trailing, spacing: -3) {
                    Text(message.readCount == 0 ? "" : message.readCount.description)
                        .foregroundStyle(.accent)
                    
                    Text(message.sendTime.toString(by: .HHmm))
                        .foregroundStyle(.gray)
                }
                
                Text(message.content)
                    .padding(10)
                    .foregroundStyle(.black)
                    .background(.accent)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .listRowSeparator(.hidden)
            .padding(.leading, 50)
        }
    }
    
    struct OpponentUserCell: View {
        @EnvironmentObject private var router: Router
        
        private let message: ChatMessage
        private let user: User
        
        init(message: ChatMessage, user: User) {
            self.message = message
            self.user = user
        }
        
        var body: some View {
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
                            Text(message.readCount == 0 ? "" : message.readCount.description)
                                .foregroundStyle(.accent)
                            
                            Text(message.sendTime.toString(by: .HHmm))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowSeparator(.hidden)
            .padding(.trailing, 50)
        }
    }
    
    /// 텍스트필드와 전송버튼을 나타내는 뷰입니다.
    struct Footer: View {
        private var isFocused: FocusState<Bool>.Binding
        @Binding private var textOnTextField: String
        
        init(isFocused: FocusState<Bool>.Binding, textOnTextField: Binding<String>) {
            self.isFocused = isFocused
            self._textOnTextField = textOnTextField
        }
        
        var body: some View {
            HStack {
                TextField("메세지를 입력해주세요", text: $textOnTextField, axis: .vertical)
                    .roundedRectangleStyle(cornerRadius: 30, vertical: 10)
                    .focused(isFocused)
                    .lineLimit(5)
                
                Button {
                    textOnTextField = ""
                    // TODO: - vm.send()
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .rotationEffect(.degrees(45))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }
}

struct ChatView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .chatView)
        }
    }
}
