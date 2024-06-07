//
//  NavigationRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path: NavigationPath
    @Published var container: DependencyContainer
    
    init(
        path: NavigationPath = NavigationPath(),
        container: DependencyContainer
    ) {
        self.path = path
        self.container = container
    }
    
    @ViewBuilder func view(to route: LoginRoute) -> some View {
        switch route {
        case .loginView: container.resolve(LoginView.self)
        }
    }
    
    func push(to destination: any Hashable) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count - 1)
    }
}
