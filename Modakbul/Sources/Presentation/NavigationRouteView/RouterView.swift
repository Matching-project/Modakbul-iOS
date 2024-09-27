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
    private let networkChecker: NetworkChecker
    
    init(router: Router,
         root: Router.Destination,
         networkChecker: NetworkChecker = NetworkChecker.shared
    ) {
        self._router = StateObject(wrappedValue: router)
        self.root = root
        self.networkChecker = networkChecker
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
                .onReceive(networkChecker.$isConnected) { isConnected in
                    if isConnected {
                        router.dismiss()
                    } else {
                        router.route(to: .networkContentUnavailableView)
                    }
                }
        }
    }
}
