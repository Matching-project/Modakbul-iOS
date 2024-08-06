//
//  AppRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol AppRouter: ObservableObject {
    associatedtype Destination: Routable where Destination == Route
    associatedtype Content: View
    
    var path: NavigationPath { get set }
    var sheet: Destination? { get set }
    var detents: Set<PresentationDetent> { get }
    var fullScreenCover: Destination? { get set }
    var confirmationContent: ConfirmationContent? { get set }
    var isModalPresented: Bool { get set }
    var isAlertPresented: Bool { get set }
    var isConfirmationDialogPresented: Bool { get set }
    var isNavigationBarBackButtonHidden: Bool { get set }
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
    @Published var fullScreenCover: Destination?
    @Published var confirmationContent: ConfirmationContent?
    @Published var isModalPresented: Bool = false
    @Published var isAlertPresented: Bool = false
    @Published var isConfirmationDialogPresented: Bool = false
    @Published var isNavigationBarBackButtonHidden: Bool = false
    
    private(set) var detents: Set<PresentationDetent> = [.large, .medium]
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
    
    private func _push(_ destination: Destination, _ isNavigationBarBackButtonHidden: Bool) {
        path.append(destination)
        self.isNavigationBarBackButtonHidden = isNavigationBarBackButtonHidden
    }
    
    private func _sheet(_ destination: Destination, _ detents: Set<PresentationDetent>) {
        guard fullScreenCover == nil else { return }
        sheet = destination
        self.detents = detents
    }
    
    private func _fullScreenCover(_ destination: Destination) {
        guard sheet == nil else { return }
        fullScreenCover = destination
    }
    
    @ViewBuilder func view(to destination: Destination) -> some View {
        destination.view(with: self)
    }
    
    func route(to destination: Destination) {
        switch destination.presentingType {
        case .push(let isNavigationBarBackButtonHidden):
            _push(destination, isNavigationBarBackButtonHidden)
        case .sheet(let detents):
            _sheet(destination, detents)
        case .fullScreenCover:
            _fullScreenCover(destination)
        }
    }
    
    func alert(for type: AlertType, actions: [ConfirmationAction]) {
        confirmationContent = type.alert(actions)
        isConfirmationDialogPresented = false
        isAlertPresented = true
    }
    
    func confirmationDialog(for type: ConfirmationDialogType, actions: [ConfirmationAction]) {
        confirmationContent = type.confirmationDialog(actions)
        isAlertPresented = false
        isConfirmationDialogPresented = true
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
