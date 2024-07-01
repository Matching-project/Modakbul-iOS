//
//  ChatView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/1/24.
//

import SwiftUI

struct ChatView<Router: AppRouter>: View where Router.Destination == Route {
    @EnvironmentObject private var router: Router
    @State var message: [ChatMessage] = []
    @State var content: String = ""
    private var chatRepository: DefaultChatRepository
    
    init(chatRepository: DefaultChatRepository) {
        self.chatRepository = chatRepository
    }
    
    var body: some View {
        VStack {
            List(message, id: \.id) { message in
                Text(message.text)
            }
            .onReceive(chatRepository.$messages) {
                message = $0
            }
            .task { @MainActor in
                do {
                    try await chatRepository.openChatRoom()
                } catch {
                    print(error)
                }
            }
            TextField("넣어줘", text: $content)
                .onSubmit {
                    Task {
                        try await chatRepository.send(message: content)
                        content = ""
                    }
                }
                .padding()
        }
    }
}
