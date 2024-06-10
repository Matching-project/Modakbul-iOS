//
//  AppRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol AppRouter: ObservableObject {
    associatedtype Destination: Routable
    associatedtype Content: View
    
    var path: NavigationPath { get set }
    var sheet: Destination? { get set }
    var fullScreenCover: Destination? { get set }
    var isPresented: Bool { get set }
    var assembler: Assembler { get }
    var resolver: DependencyResolver { get }
    
    @ViewBuilder func view(to destination: Destination) -> Content
    func push(to destination: Destination)
    func dismiss()
    func popToRoot()
}

extension AppRouter {
    var resolver: DependencyResolver { assembler.resolver }
    var isPresented: Bool { sheet != nil || fullScreenCover != nil }
}

final class DefaultAppRouter: AppRouter {
    typealias Destination = Route
    
    @Published var path: NavigationPath
    @Published var sheet: Destination?
    @Published var fullScreenCover: Destination?
    @Published var isPresented: Bool = false
    let assembler: Assembler
    
    init(
        path: NavigationPath = NavigationPath(),
        assembler: Assembler
    ) {
        self.path = path
        self.assembler = assembler
    }
    
    convenience init(
        by assemblies: Assembly...
    ) {
        let assembler = Assembler(by: assemblies)
        self.init(assembler: assembler)
    }
    
    @ViewBuilder func view(to destination: Destination) -> some View {
        switch destination {
        case .homeView: HomeView<DefaultAppRouter>(homeViewModel: resolver.resolve(HomeViewModel.self))
        case .loginView: LoginView<DefaultAppRouter>(loginViewModel: resolver.resolve(LoginViewModel.self))
        case .myView: MyView()
        }
    }
    
    func push(to destination: Route) {
        path.append(destination)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count - 1)
    }
}
