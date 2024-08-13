//
//  Route.swift
//  Modakbul
//
//  Created by Swain Yun on 5/24/24.
//

import SwiftUI

protocol Routable: Identifiable, Hashable {
    associatedtype Content: View
    associatedtype Router: AppRouter
    
    var presentingType: PresentingType { get }
    
    @ViewBuilder func view(with router: Router) -> Content
}

extension Routable {
    var id: String { String(describing: self) }
}

enum PresentingType {
    case push
    case sheet(detents: Set<PresentationDetent>)
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
    case notificationView
    case placeShowcaseView
    case mapArea
    case placesListArea
    case placeInformationView(place: Place)
    case placeInformationDetailView(communityRecruitingContentId: String)
    case placeInformationDetailMakingView
    case participationRequestListView(communityRecruitingContent: CommunityRecruitingContent)
    
    var presentingType: PresentingType {
        switch self {
        case .routerView: return .push
        case .contentView: return .push
        case .loginView: return .fullScreenCover
        case .homeView: return .push
        case .myView: return .sheet(detents: [.medium, .large])
        case .chatView: return .push
        case .placeShowcaseView: return .push
        case .notificationView: return .push
        case .mapArea: return .push
        case .placesListArea: return .push
        case .placeInformationView: return .sheet(detents: [.medium, .large])
        case .placeInformationDetailView: return .push
        case .placeInformationDetailMakingView: return .push
        case .participationRequestListView: return .push
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
        case .notificationView:
            NotificationView<Router>(router.resolver.resolve(NotificationViewModel.self))
        case .chatView:
            ChatView<Router>(chatRepository: router.resolver.resolve(ChatRepository.self))
        case .mapArea:
            MapArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placesListArea:
            PlacesListArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placeInformationView(let place):
            PlaceInformationView<Router>(place: place)
        case .placeInformationDetailView(let communityRecruitingContentId):
            PlaceInformationDetailView<Router>(communityRecruitingContentId: communityRecruitingContentId)
        case .placeInformationDetailMakingView:
            PlaceInformationDetailMakingView<Router>(router.resolver.resolve(PlaceInformationDetailMakingViewModel.self))
        case .participationRequestListView(let communityRecruitingContent):
            ParticipationRequestListView<Router>(participationRequestListViewModel: router.resolver.resolve(ParticipationRequestListViewModel.self), communityRecruitingContent: communityRecruitingContent)
        }
    }
}

// MARK: Equatable Confirmation
extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

// MARK: Hashable Confirmation
extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
