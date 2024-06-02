//
//  NavigationRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path: NavigationPath
    
    init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }
    
    @ViewBuilder func view(to route: LoginRoute) -> some View {
        switch route {
        case .loginView: LoginView()
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
