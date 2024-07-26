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
}

struct ContentView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        TabView {
            router.view(to: .homeView)
                .tabItemStyle(.home)
            
            // MARK: 기존에 .loginView로 기능 테스트했었음
            router.view(to: .chatView)
                .tabItemStyle(.chattings)
            
            router.view(to: .myView)
                .tabItemStyle(.settings)
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .contentView)
    }
}
