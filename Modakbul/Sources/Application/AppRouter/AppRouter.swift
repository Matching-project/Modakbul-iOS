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
    
    // Properties
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
    
    // Dependencies
    var routerAdaptor: RouterAdapter { get }
    
    @ViewBuilder func view(to destination: Destination) -> Content
    func route(to destination: Destination)
    func alert(for type: AlertType, actions: [ConfirmationAction])
    func confirmationDialog(for type: ConfirmationDialogType, actions: [ConfirmationAction])
    func dismiss()
    func popToRoot()
}

extension AppRouter {
    var resolver: DependencyResolver { assembler.resolver }
    var routerAdaptor: RouterAdapter { .shared }
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
    
    private(set) var detents: Set<PresentationDetent> = [.large, .medium]
    let assembler: Assembler
    private let sheetSubject = PassthroughSubject<Destination, Never>()
    private let fullScreenCoverSubject = PassthroughSubject<Destination, Never>()
    private let alertSubject = PassthroughSubject<ConfirmationContent, Never>()
    private let confirmationDialogSubject = PassthroughSubject<ConfirmationContent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        path: NavigationPath = NavigationPath(),
        assembler: Assembler
    ) {
        self.path = path
        self.assembler = assembler
        subscribe()
    }
    
    convenience init(
        by assemblies: Assembly...
    ) {
        let assembler = Assembler(by: assemblies)
        self.init(assembler: assembler)
    }
    
    private func subscribe() {
        routerAdaptor.$destionation
            .sink { [weak self] destination in
                guard let destination = destination else { return }
                self?.route(to: destination)
            }
            .store(in: &cancellables)
        
        sheetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.sheet = route
            }
            .store(in: &cancellables)
        
        fullScreenCoverSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.fullScreenCover = route
            }
            .store(in: &cancellables)
        
        alertSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.confirmationContent = alert
                self?.isConfirmationDialogPresented = false
                self?.isAlertPresented = true
            }
            .store(in: &cancellables)
        
        confirmationDialogSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] confirmationDialog in
                self?.confirmationContent = confirmationDialog
                self?.isAlertPresented = false
                self?.isConfirmationDialogPresented = true
            }
            .store(in: &cancellables)
    }
    
    private func _push(_ destination: Destination) {
        path.append(destination)
    }
    
    private func _sheet(_ destination: Destination, _ detents: Set<PresentationDetent>) {
        guard isModalPresented == false else { return }
        sheetSubject.send(destination)
        self.detents = detents
    }
    
    private func _fullScreenCover(_ destination: Destination) {
        guard isModalPresented == false else { return }
        fullScreenCoverSubject.send(destination)
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
        let confirmationContent = type.alert(actions)
        alertSubject.send(confirmationContent)
    }
    
    func confirmationDialog(for type: ConfirmationDialogType, actions: [ConfirmationAction]) {
        let confirmationContent = type.confirmationDialog(actions)
        confirmationDialogSubject.send(confirmationContent)
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
