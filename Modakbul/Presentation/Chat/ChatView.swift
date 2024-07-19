//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI

// TODO: ChatViewModel 만들어야 함
struct ChatView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @State var message: [ChatMessage] = []
    private var chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    var body: some View {
        Text("ChatView")
    }
}
