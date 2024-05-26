//
//  NavigationRouteView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

struct NavigationRouteView<Content: View>: View {
    @StateObject private var router = AppRouter()
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: LoginRoute.self) { route in
                    router.view(to: route)
                }
        }
        .environmentObject(router)
    }
}
