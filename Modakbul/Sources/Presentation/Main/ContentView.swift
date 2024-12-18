//
//  ContentView.swift
//  modakbul
//
//  Created by 김강현 on 5/17/24.
//

import SwiftUI

enum PageType {
    case home, chattings, settings
    
    var label: Label<Text, Image> {
        switch self {
        case .home:
            Label("홈", systemImage: "house")
        case .chattings:
            Label("채팅", systemImage: "bubble")
        case .settings:
            Label("마이페이지", systemImage: "person")
        }
    }
    
    var navigationTitle: String {
        return self == .chattings ? "채팅" : String()
    }
}

struct ContentView<Router: AppRouter>: View {
    @ObservedObject private var vm: ContentViewModel
    @EnvironmentObject private var router: Router
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @State private var selectedPage: PageType = .home
    
    init(_ contentViewModel: ContentViewModel) {
        self.vm = contentViewModel
    }
    
    var body: some View {
        TabView(selection: $selectedPage) {
            router.view(to: .homeView)
                .tabItemStyle(.home)

            if userId != Constants.loggedOutUserId {
                router.view(to: .chatRoomListView)
                    .tabItemStyle(.chattings)
            }
            
            router.view(to: .myView)
                .tabItemStyle(.settings)
        }
        .onAppear {
            vm.readMyProfile(Int64(userId))
        }
        .onReceive(vm.$user) { user in
            userId = Int(user.id)
        }
        .navigationTitle(selectedPage.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .contentView)
        }
    }
}
