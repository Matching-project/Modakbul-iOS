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
            Label("My", systemImage: "person")
        }
    }
    
    var navigationTitle: String {
        return self == .chattings ? "채팅" : String()
    }
}

struct ContentView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @State private var selectedPage: PageType = .home
    
    var body: some View {
        TabView(selection: $selectedPage) {
            router.view(to: .homeView)
                .tabItemStyle(.home)

            router.view(to: .chatRoomListView)
                .tabItemStyle(.chattings)
            
            router.view(to: .myView)
                .tabItemStyle(.settings)
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
