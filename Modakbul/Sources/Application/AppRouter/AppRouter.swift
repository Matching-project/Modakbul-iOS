//
//  AppRouter.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI
import Combine

protocol AppRouter: ObservableObject {
    associatedtype Destination: Routable where Destination == Route
    associatedtype Content: View
    
    var path: NavigationPath { get set }
    var sheet: Destination? { get set }
    var detents: Set<PresentationDetent> { get }
    var fullScreenCover: Destination? { get set }
    var confirmationContent: ConfirmationContent? { get set }
    var isModalPresented: Bool { get }
    var isAlertPresented: Bool { get set }
    var isConfirmationDialogPresented: Bool { get set }
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
    var isModalPresented: Bool { sheet != nil || fullScreenCover != nil }
    @Published var isAlertPresented: Bool = false
    @Published var isConfirmationDialogPresented: Bool = false
    @Published var notification: Destination? = RouterAdapter.shared.destionation {
        didSet {
            if let notification = notification {
                route(to: notification)
            }
        }
    }
    
    private(set) var detents: Set<PresentationDetent> = [.large, .medium]
    let assembler: Assembler
    private var cancellable: AnyCancellable?
    
    init(
        path: NavigationPath = NavigationPath(),
        assembler: Assembler
    ) {
        self.path = path
        self.assembler = assembler
        
        cancellable = RouterAdapter.shared.$destionation
            .assign(to: \.notification, on: self)
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
    
    private func _sheet(_ destination: Destination, _ detents: Set<PresentationDetent>) {
        guard isModalPresented == false else { return }
        sheet = destination
        self.detents = detents
    }
    
    private func _fullScreenCover(_ destination: Destination) {
        guard isModalPresented == false else { return }
        fullScreenCover = destination
    }
    
    @ViewBuilder func view(to destination: Destination) -> some View {
        destination.view(with: self)
            .environment(\.font, .Modakbul.callout)
            .environmentObject(self)
    }
    
    func route(to destination: Destination) {
        switch destination.presentingType {
        case .push:
            _push(destination)
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
        if isModalPresented {
            fullScreenCover = nil
            sheet = nil
        }
        
        if path.isEmpty == false {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        if isModalPresented {
            sheet = nil
            fullScreenCover = nil
        }
        
        if path.isEmpty == false {
            path.removeLast(path.count)
        }
    }
}
