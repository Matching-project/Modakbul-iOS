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

struct ContentView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        TabView {
            HomeView()
                .tabItemStyle(.home)
                .environmentObject(router)
            
            Text("채팅 내역")
                .tabItemStyle(.chattings)
            
            Text("My페이지")
                .tabItemStyle(.settings)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PreviewHelper.shared.router)
}
