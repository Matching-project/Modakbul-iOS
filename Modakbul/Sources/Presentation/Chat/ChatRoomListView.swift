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
    @Binding private var selectedPage: PageType
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    private let archivedPage: PageType
    
    @State private var chatRooms: [Item] = [
        (UUID(), nil, "디자인 천재", "네 오늘 너무 유익했어요!", .now, 10),
        (UUID(), nil, "웹 개발 10년차", "좋아요!", .now, 1),
        (UUID(), nil, "똑똑똑한박사", "알겠습니다~감사합니다.", .now, 11)
    ]
    
    init(selectedPage: Binding<PageType>, archivedPage: PageType) {
        self._selectedPage = selectedPage
        self.archivedPage = archivedPage
    }
    
    var body: some View {
        if isLoggedIn {
            chatRoomList
        } else {
            loginPrompt
        }
    }
}

extension ChatRoomListView {
    private var chatRoomList: some View {
        List(chatRooms, id: \.id) { room in
            Cell(room)
        }
        .listStyle(.plain)
    }
    
    private var loginPrompt: some View {
        Text("")
            .onAppear {
                router.loginAlert(cancelAction: { selectedPage = archivedPage })
            }
    }
    
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
                        .font(.headline)
                    
                    Text(chatRoom.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text(chatRoom.time.toString(by: .ahmm))
                        .font(.subheadline)
                    
                    Badge(count: chatRoom.unreadCount)
                }
            }
        }
    }
}

struct ChatRoomListView_Preview: PreviewProvider {
    @State private static var selectedPage: PageType = .home
    static var previews: some View {
        // MARK: - Preview에서는 선택된 뷰만 표출하므로, 화면 이동간 로직이 포함된 archivedPage을 .home으로 처리했으니 정확한 동작은 Simulator를 이용 바랍니다.
        router.view(to: .chatRoomListView(selectedPage: $selectedPage, archivedPage: .home))
    }
}
