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
    case loginView          // MARK: - Login
    case requiredTermView   // MARK: - Registration
    case registrationView
    case myView             // MARK: - My
    case profileEditView
    case placeShowcaseView(userId: Int64)
    case placeReviewView(place: Place?)
    case notificationSettingsView
    case homeView           // MARK: - Home
    case mapArea
    case placesListArea
    case placeInformationView(place: Place, displayMode: PlaceInformationView<Route.Router>.DisplayMode)
    case placeInformationDetailView(communityRecruitingContentId: Int64)
    case placeInformationDetailMakingView
    case participationRequestListView(communityRecruitingContent: CommunityRecruitingContent, userId: Int64)
    case notificationView
    case chatView           // MARK: - Chat
    case chatRoomListView
    case reportView(result: Binding<Bool>)
    case profileDetailView  // MARK: - Common
    
    var presentingType: PresentingType {
        switch self {
        case .routerView: return .push
        case .contentView: return .push
        case .loginView: return .fullScreenCover                    // MARK: - Login
        case .requiredTermView: return .sheet(detents: [.medium])   // MARK: - Registration
        case .registrationView: return .push
        case .myView: return .sheet(detents: [.medium, .large])     // MARK: - My
        case .placeShowcaseView: return .push
        case .placeReviewView: return .push
        case .profileEditView: return .push
        case .notificationSettingsView: return .push
        case .homeView: return .push                                // MARK: - Home
        case .mapArea: return .push
        case .placesListArea: return .push
        case .placeInformationView: return .sheet(detents: [.medium, .large])
        case .placeInformationDetailView: return .push
        case .placeInformationDetailMakingView: return .push
        case .participationRequestListView: return .push
        case .notificationView: return .push
        case .chatView: return .push                                // MARK: - Chat
        case .chatRoomListView: return .push
        case .reportView: return .push
        case .profileDetailView: return .push                       // MARK: - Common
        }
    }
    
    @ViewBuilder func view(with router: Router) -> some View {
        switch self {
        case .routerView:
            RouterView<Router>(router: router, root: .contentView)
        case .contentView:
            ContentView<Router>()
        case .loginView:        // MARK: - Login
            LoginView<Router>(loginViewModel: router.resolver.resolve(LoginViewModel.self))
        case .requiredTermView: // MARK: - Registration
            RequiredTermView<Router>()
        case .registrationView:
            RegistrationView<Router>(registrationViewModel: router.resolver.resolve(RegistrationViewModel.self))
        case .myView:           // MARK: - My
            MyView<Router>(myViewModel: router.resolver.resolve(MyViewModel.self))
        case .placeShowcaseView(let userId):
            PlaceShowcaseView<Router>(router.resolver.resolve(PlaceShowcaseViewModel.self), userId: userId)
        case .placeReviewView(let place):
            PlaceReviewView(router.resolver.resolve(PlaceReviewViewModel.self), place: place)
        case .profileEditView:
            ProfileEditView<Router>(profileEditViewModel: router.resolver.resolve(ProfileEditViewModel.self))
        case .notificationSettingsView:
            NotificationSettingsView<Router>(notificationSettingsViewModel: router.resolver.resolve(NotificationSettingsViewModel.self))
        case .homeView:         // MARK: - Home
            HomeView<Router>(router.resolver.resolve(HomeViewModel.self))
        case .mapArea:
            MapArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placesListArea:
            PlacesListArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placeInformationView(let place, let displayMode):
            PlaceInformationView<Router>(router.resolver.resolve(PlaceInformationViewModel.self), place: place, displayMode: displayMode)
        case .placeInformationDetailView(let communityRecruitingContentId):
            PlaceInformationDetailView<Router>(router.resolver.resolve(PlaceInformationDetailViewModel.self), communityRecruitingContentId: communityRecruitingContentId)
        case .placeInformationDetailMakingView:
            PlaceInformationDetailMakingView<Router>(router.resolver.resolve(PlaceInformationDetailMakingViewModel.self))
        case .participationRequestListView(let communityRecruitingContent, let userId):
            ParticipationRequestListView<Router>(participationRequestListViewModel: router.resolver.resolve(ParticipationRequestListViewModel.self), communityRecruitingContent: communityRecruitingContent, userId: userId)
        case .notificationView:
            NotificationView<Router>(router.resolver.resolve(NotificationViewModel.self))
        case .chatView:         // MARK: - Chat
            ChatView<Router>(router.resolver.resolve(ChatViewModel.self))
        case .chatRoomListView:
            ChatRoomListView()
        case .reportView(let isReported):
            ReportView<Router>(router.resolver.resolve(ReportViewModel.self), isReported: isReported)
        case .profileDetailView:
            ProfileDetailView<Router>(profileDetailViewModel: router.resolver.resolve(ProfileDetailViewModel.self))
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
