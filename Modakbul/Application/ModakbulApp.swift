//
//  modakbulApp.swift
//  modakbul
//
//  Created by 김강현 on 5/17/24.
//

import SwiftUI

@main
struct ModakbulApp: App {
    @ObservedObject private var router: AppRouter
//    private let assembler: Assembler
    
    init() {
        self.router = AppRouter()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
            }
        }
    }
}
