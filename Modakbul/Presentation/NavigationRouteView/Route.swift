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
    case push
    case sheet(detent: PresentationDetent)
    case fullScreenCover
}

enum Route: Routable {
    typealias Router = DefaultAppRouter
    
    case loginView
    case homeView
    case myView
    case placeShowcaseView
    
    var presentingType: PresentingType {
        switch self {
        case .loginView: return .fullScreenCover
        case .homeView: return .push
        case .myView: return .sheet(detent: .medium)
        case .placeShowcaseView: return .push
        }
    }
    
    @ViewBuilder func view(with router: Router) -> some View {
        switch self {
        case .loginView:
            LoginView<Router>(loginViewModel: router.resolver.resolve(LoginViewModel.self))
        case .homeView:
            HomeView<Router>(homeViewModel: router.resolver.resolve(HomeViewModel.self))
        case .myView:
            MyView<Router>()
        case .placeShowcaseView:
            PlaceShowcaseView<Router>(placeShowcaseViewModel: router.resolver.resolve(PlaceShowcaseViewModel.self))
        }
    }
}
