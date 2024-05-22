//
//  ContentView.swift
//  modakbul
//
//  Created by 김강현 on 5/17/24.
//

import SwiftUI

@frozen enum PageType {
    case home, chattings, settings
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tag(PageType.home)
                .tabItem { Label("홈", systemImage: "house") }
            
            Text("채팅 내역")
                .tag(PageType.chattings)
                .tabItem { Label("채팅", systemImage: "bubble") }
            
            Text("My페이지")
                .tag(PageType.settings)
                .tabItem { Label("My", systemImage: "person") }
        }
    }
}

#Preview {
    ContentView()
}
