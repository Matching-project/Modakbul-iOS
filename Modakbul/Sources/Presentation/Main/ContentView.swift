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
    @State private var archivedPage: PageType = .home
    
    var body: some View {
        TabView(selection: $selectedPage) {
            router.view(to: .homeView)
                .tabItemStyle(.home)
            
            router.view(to: .chatRoomListView(selectedPage: $selectedPage, archivedPage: archivedPage))
                .tabItemStyle(.chattings)
            
            router.view(to: .myView)
                .tabItemStyle(.settings)
        }
        .navigationTitle(selectedPage.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPage) {
            updateArchivedPage(from: selectedPage)
        }
    }
    
    private func updateArchivedPage(from selectedPage: PageType) {
        // MARK: - 채팅 화면은 비로그인시 접속할 수 없습니다. 따라서, 사용자가 비로그인 상태에서 채팅 화면에 접속했을 때, 로그인을 하지 않는 경우 이전 페이지로 돌아갑니다.
        if selectedPage != .chattings {
            archivedPage = selectedPage
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .contentView)
        }
    }
}
