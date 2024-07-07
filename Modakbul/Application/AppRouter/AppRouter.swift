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
    var confirmationContent: ConfirmationContent? { get set }
    var isModalPresented: Bool { get set }
    var isConfirmationContentPresented: Bool { get set }
    var assembler: Assembler { get }
    var resolver: DependencyResolver { get }
    
    @ViewBuilder func view(to destination: Destination) -> Content
    func route(to destination: Destination)
    func alert(for type: AlertType, actions: [ConfirmationAction])
    func confirmationDialog(for type: ConfirmationDialogType, actions: [ConfirmationAction])
    func dismiss()
    func popToRoot()
}

extension AppRouter {
    var resolver: DependencyResolver { assembler.resolver }
}

final class DefaultAppRouter: AppRouter {
    typealias Destination = Route
    
    @Published var path: NavigationPath
    @Published var sheet: Destination?
    @Published var detent: PresentationDetent = .large
    @Published var fullScreenCover: Destination?
    @Published var confirmationContent: ConfirmationContent?
    @Published var isModalPresented: Bool = false
    @Published var isConfirmationContentPresented: Bool = false
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
    
    private func _push(_ destination: Destination) {
        path.append(destination)
    }
    
    private func _sheet(_ destination: Destination, _ detent: PresentationDetent) {
        guard fullScreenCover == nil else { return }
        sheet = destination
        self.detent = detent
    }
    
    private func _fullScreenCover(_ destination: Destination) {
        guard sheet == nil else { return }
        fullScreenCover = destination
    }
    
    @ViewBuilder func view(to destination: Destination) -> some View {
        switch destination {
        case .homeView: HomeView<DefaultAppRouter>(homeViewModel: resolver.resolve(HomeViewModel.self))
        case .loginView: LoginView<DefaultAppRouter>(loginViewModel: resolver.resolve(LoginViewModel.self))
        case .myView: MyView()
        }
    }
    
    func route(to destination: Destination) {
        switch destination.presentingType {
        case .push:
            _push(destination)
        case .sheet(let detent):
            _sheet(destination, detent)
        case .fullScreenCover:
            _fullScreenCover(destination)
        }
    }
    
    func alert(for type: AlertType, actions: [ConfirmationAction]) {
        confirmationContent = type.alert(actions)
        isConfirmationContentPresented = true
    }
    
    func confirmationDialog(for type: ConfirmationDialogType, actions: [ConfirmationAction]) {
        confirmationContent = type.confirmationDialog(actions)
        isConfirmationContentPresented = true
    }
    
    func dismiss() {
        if fullScreenCover != nil {
            fullScreenCover = nil
        } else if sheet != nil {
            sheet = nil
        } else if path.isEmpty == false {
            path.removeLast()
        } else if isModalPresented {
            isModalPresented = false
        }
    }
    
    func popToRoot() {
        if sheet != nil {
            sheet = nil
        }
        
        if fullScreenCover != nil {
            fullScreenCover = nil
        }
        
        if isModalPresented {
            isModalPresented = false
        }
        
        path.removeLast(path.count)
    }
}
