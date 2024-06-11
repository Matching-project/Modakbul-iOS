//
//  RouterView.swift
//  Modakbul
//
//  Created by Swain Yun on 6/10/24.
//

import SwiftUI

struct RouterView<Content: View, Router: AppRouter>: View {
    @StateObject private var router: Router
    private let content: Content
    private let detents: Set<PresentationDetent> = [.large, .medium]
    
    init(router: Router, @ViewBuilder content: () -> Content) {
        self._router = StateObject(wrappedValue: router)
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Destination.self) { destination in
                    router.view(to: destination)
                }
        }
        .sheet(item: $router.sheet) { destination in
            router.view(to: destination)
                .presentationDetents(detents, selection: $router.detent)
        }
        .fullScreenCover(item: $router.fullScreenCover) { destination in
            router.view(to: destination)
        }
        .environmentObject(router)
    }
}
