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
    var detent: PresentationDetent { get set }
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
    
    @Published var path: NavigationPath { willSet { print("\(newValue)로 바뀜") } }
    @Published var sheet: Destination? { willSet { print("\(newValue)로 바뀜") } }
    @Published var detent: PresentationDetent = .large
    @Published var fullScreenCover: Destination? { willSet { print("\(newValue)로 바뀜") } }
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
    
    func push(to destination: Destination) {
        switch destination.presentingType {
        case .push: path.append(destination)
        case .sheet(let detent): sheet = destination; self.detent = detent
        case .fullScreenCover: fullScreenCover = destination
        }
    }
    
    func dismiss() {
        if path.isEmpty == false {
            path.removeLast()
        } else if sheet != nil {
            sheet = nil
        } else if fullScreenCover != nil {
            fullScreenCover = nil
        } else if isPresented {
            isPresented = false
        }
    }
    
    func popToRoot() {
        if sheet != nil {
            sheet = nil
        }
        
        if fullScreenCover != nil {
            fullScreenCover = nil
        }
        
        if isPresented {
            isPresented = false
        }
        
        path.removeLast(path.count - 1)
    }
}
