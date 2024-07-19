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
    private var chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    var body: some View {
        Text("ChatView")
    }
}
