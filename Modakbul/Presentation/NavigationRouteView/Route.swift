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
    
    // MARK: Default PresentingType without parameter
    static var push: PresentingType {
        .push(isNavigationBarBackButtonHidden: false)
    }
}

enum Route: Routable {
    typealias Router = DefaultAppRouter
    
    case routerView
    case contentView
    case loginView            // MARK: - Login
    case myView               // MARK: - My
    case placeShowcaseView
    case homeView             // MARK: - Home
    case mapArea
    case placesListArea
    case placeInformationView(place: Place)
    case placeInformationDetailView(communityRecruitingContentId: String)
    case placeInformationDetailMakingView
    case participationRequestListView(communityRecruitingContent: CommunityRecruitingContent)
    case notificationView
    case chatView   // MARK: - Chat
    case chatRoomListView
    case reportView
    
    var presentingType: PresentingType {
        switch self {
        case .routerView: return .push
        case .contentView: return .push
        case .loginView: return .fullScreenCover                // MARK: - Login
        case .myView: return .sheet(detents: [.medium, .large]) // MARK: - My
        case .placeShowcaseView: return .push
        case .homeView: return .push                            // MARK: - Home
        case .mapArea: return .push
        case .placesListArea: return .push
        case .placeInformationView: return .sheet(detents: [.medium, .large])
        case .placeInformationDetailView: return .push
        case .placeInformationDetailMakingView: return .push
        case .participationRequestListView: return .push
        case .notificationView: return .push
        case .chatView: return .push                            // MARK: - Chat
        case .chatRoomListView: return .push
        case .reportView: return .push
        }
    }
    
    @ViewBuilder func view(with router: Router) -> some View {
        switch self {
        case .routerView:
            RouterView<Router>(router: router, root: .contentView)
        case .contentView:
            ContentView<Router>()
        case .loginView:    // MARK: - Login
            LoginView<Router>(loginViewModel: router.resolver.resolve(LoginViewModel.self))
        case .myView:       // MARK: - My
            MyView<Router>()
        case .placeShowcaseView:
            PlaceShowcaseView<Router>(placeShowcaseViewModel: router.resolver.resolve(PlaceShowcaseViewModel.self))
        case .homeView:     // MARK: - Home
            HomeView<Router>(homeViewModel: router.resolver.resolve(HomeViewModel.self))
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
        case .notificationView:
            NotificationView<Router>(router.resolver.resolve(NotificationViewModel.self))
        case .chatView:     // MARK: - Chat
            ChatView<Router>(router.resolver.resolve(ChatViewModel.self))
        case .chatRoomListView:
            ChatRoomListView()
        case .reportView:
            ReportView<Router>(router.resolver.resolve(ReportViewModel.self))
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
