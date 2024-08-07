//
//  RouterView.swift
//  Modakbul
//
//  Created by Swain Yun on 6/10/24.
//

import SwiftUI

struct RouterView<Router: AppRouter>: View {
    @StateObject private var router: Router
    private let root: Router.Destination
    private let detents: Set<PresentationDetent> = [.large, .medium]
    
    init(router: Router, root: Router.Destination) {
        self._router = StateObject(wrappedValue: router)
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(to: root)
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
        .alert(isPresented: $router.isAlertPresented, router.confirmationContent)
        .confirmationDialog(isPresented: $router.isConfirmationDialogPresented, router.confirmationContent)
        .environmentObject(router)
    }
}
