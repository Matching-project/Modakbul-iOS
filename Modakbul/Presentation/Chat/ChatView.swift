//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
}

struct ChatView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    @ObservedObject private var chatViewModel: ChatViewModel
    
    init(_ chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
    }
    
    var body: some View {
        Text("ChatView")
    }
}

extension ChatView {
    struct MessageCell: View {
        private let text: String
        private let isMine: Bool
        
        init(_ text: String, _ isMine: Bool) {
            self.text = text
            self.isMine = isMine
        }
        
        var body: some View {
            Text(text)
                .padding(10)
                .foregroundColor(isMine ? .white : .black)
                .background(isMine ? .accent : .secondary)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

struct ChatView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .chatView)
    }
}
