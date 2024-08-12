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
    
    case routerView
    case contentView
    case loginView
    case homeView
    case myView
    case chatView
    case placeShowcaseView
<<<<<<< Updated upstream
=======
    case mapArea
    case placesListArea
    case placeInformationView(place: Place)
    case placeInformationDetailView(communityRecruitingContentId: String)
    case placeInformationDetailMakingView
    case participationRequestListView(communityRecruitingContent: CommunityRecruitingContent)
>>>>>>> Stashed changes
    
    var presentingType: PresentingType {
        switch self {
        case .routerView: return .push
        case .contentView: return .push
        case .loginView: return .fullScreenCover
        case .homeView: return .push
        case .myView: return .sheet(detent: .medium)
        case .chatView: return .push
        case .placeShowcaseView: return .push
<<<<<<< Updated upstream
=======
        case .mapArea: return .push
        case .placesListArea: return .push
        case .placeInformationView: return .sheet(detents: [.medium, .large])
        case .placeInformationDetailView: return .push
        case .placeInformationDetailMakingView: return .push
        case .participationRequestListView: return .push
>>>>>>> Stashed changes
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
        case .homeView:
            HomeView<Router>(homeViewModel: router.resolver.resolve(HomeViewModel.self))
        case .myView:
            MyView<Router>()
        case .placeShowcaseView:
            PlaceShowcaseView<Router>(placeShowcaseViewModel: router.resolver.resolve(PlaceShowcaseViewModel.self))
        case .chatView:
            ChatView<Router>(chatRepository: router.resolver.resolve(ChatRepository.self))
<<<<<<< Updated upstream
=======
        case .mapArea:
            MapArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placesListArea:
            PlacesListArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placeInformationView(let place):
            PlaceInformationView<Router>(place: place)
        case .placeInformationDetailView(let communityRecruitingContentId):
            PlaceInformationDetailView<Router>(communityRecruitingContentId: communityRecruitingContentId)
        case .placeInformationDetailMakingView:
            PlaceInformationDetailMakingView<Router>()
        case .participationRequestListView(let communityRecruitingContent):
            ParticipationRequestListView<Router>(participationRequestListViewModel: router.resolver.resolve(ParticipationRequestListViewModel.self), communityRecruitingContent: communityRecruitingContent)
>>>>>>> Stashed changes
        }
    }
}
