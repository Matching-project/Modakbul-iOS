//
//  Route.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol Routable: Hashable, Identifiable {
    associatedtype Content: View
    associatedtype Router: AppRouter
    
    var presentingType: PresentingType { get }
    
    @ViewBuilder func view(with router: Router) -> Content
}

extension Routable {
    var id: Self { self }
}

enum PresentingType {
    case push(isNavigationBarBackButtonHidden: Bool)
    case sheet(detents: Set<PresentationDetent>)
    case fullScreenCover
    
    // MARK: Default PresentingType without parameter
    static var push: PresentingType {
        .push(isNavigationBarBackButtonHidden: false)
    }
}

enum Route: Routable {
    typealias Router = DefaultAppRouter
    
    case routerView
    case contentView
    case loginView
    case requiredTermsView
    case registrationView
    case homeView
    case myView
    case chatView
    case placeShowcaseView
    
    var presentingType: PresentingType {
        switch self {
        case .routerView: return .push
        case .contentView: return .push
        case .loginView: return .fullScreenCover
        case .requiredTermsView: return .sheet(detents: [.medium])
        case .registrationView: return .push(isNavigationBarBackButtonHidden: true)
        case .homeView: return .push
        case .myView: return .sheet(detents: [.medium])
        case .chatView: return .push
        case .placeShowcaseView: return .push
        }
    }
    
    @ViewBuilder func view(with router: Router) -> some View {
        switch self {
        case .routerView:
            RouterView<Router>(router: router, root: .contentView)
        case .contentView:
            ContentView<Router>()
        case .loginView:
            LoginView<Router>(loginViewModel: router.resolver.resolve(LoginViewModel.self))
        case .requiredTermsView:
            RequiredTermView<Router>()
        case .registrationView:
            RegistrationView<Router>(registrationViewModel: router.resolver.resolve(RegistrationViewModel.self))
        case .homeView:
            HomeView<Router>(homeViewModel: router.resolver.resolve(HomeViewModel.self))
        case .myView:
            MyView<Router>()
        case .placeShowcaseView:
            PlaceShowcaseView<Router>(placeShowcaseViewModel: router.resolver.resolve(PlaceShowcaseViewModel.self))
        case .chatView:
            ChatView<Router>(chatRepository: router.resolver.resolve(ChatRepository.self))
        }
    }
}
