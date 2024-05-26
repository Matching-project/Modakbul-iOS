//
//  NavigationRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol RouterProtocol {
    var router: AppRouter { get }
}

final class AppRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(to route: Route) -> some View {
        switch route {
        case .loginView: LoginView()
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
