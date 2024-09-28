//
//  RouterView.swift
//  Modakbul
//
//  Created by Swain Yun on 6/10/24.
//

import SwiftUI

struct RouterView<Router: AppRouter>: View {
    @EnvironmentObject private var networkChecker: NetworkChecker
    @ObservedObject private var router: Router
    
    private let root: Router.Destination
    
    init(
        router: Router,
        root: Router.Destination
    ) {
        self._router = ObservedObject(initialValue: router)
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(to: root)
                .navigationDestination(for: Router.Destination.self) { destination in
                    router.view(to: destination)
                }
                .sheet(item: $router.sheet) { destination in
                    router.view(to: destination)
                        .presentationDetents(router.detents)
                }
                .fullScreenCover(item: $router.fullScreenCover) { destination in
                    router.view(to: destination)
                }
                .alert(isPresented: $router.isAlertPresented, router.confirmationContent)
                .confirmationDialog(isPresented: $router.isConfirmationDialogPresented, router.confirmationContent)
                .onChange(of: networkChecker.isConnected) { before, after in
                    // 인터넷 off -> on
                    if before == false, after == true { router.dismiss() }
                    
                    // 인터넷 on -> off
                    if before == true, after == false { router.route(to: .networkContentUnavailableView) }
                }
        }
    }
}
