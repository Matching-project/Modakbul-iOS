//
//  NavigationRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

enum Route: Hashable {
    case loginView
    case homeView
}

final class NavigationRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(to route: Route) -> some View {
        switch route {
        case .loginView: LoginView()
        case .homeView: HomeView()
        }
    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count - 1)
    }
}
