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

struct ContentView<Router: AppRouter>: View where Router.Destination == Route {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        TabView {
            router.view(to: .homeView)
                .tabItemStyle(.home)
            
            router.view(to: .loginView)
                .tabItemStyle(.chattings)
            
            router.view(to: .myView)
                .tabItemStyle(.settings)
        }
    }
}
