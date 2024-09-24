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
    case requiredTermView(userCredential: UserCredential)    // MARK: - Registration
    case registrationView(userCredential: UserCredential)
    case myView             // MARK: - My
    case profileEditView(user: User)
    case myCommunityRecruitingContentListView
    case myCommunityListView
    case myParticipationRequestListView
    case blockedListView
    case reportListView
    case placeShowcaseView(userId: Int64)
    case placeReviewView(place: Place?)
    case notificationSettingsView
    case unregisterView(user: User)
    case homeView           // MARK: - Home
    case mapArea
    case placesListArea
    case placeInformationView(place: Place)
    case placeInformationDetailView(communityRecruitingContentId: Int64, userId: Int64)
    case placeInformationDetailMakingView(place: Place, communityRecruitingContent: CommunityRecruitingContent?)
    case participationRequestListView(communityRecruitingContent: CommunityRecruitingContent, userId: Int64)
    case notificationView(userId: Int64)
    case chatView           // MARK: - Chat
    case chatRoomListView
    case reportView(opponentUserId: Int64, isReported: Binding<Bool>)
    case profileDetailView(opponentUserId: Int64)  // MARK: - Common
    
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
        case .myCommunityRecruitingContentListView: return .push
        case .myCommunityListView: return .push
        case .myParticipationRequestListView: return .push
        case .blockedListView: return .push
        case .reportListView: return .push
        case .notificationSettingsView: return .push
        case .unregisterView: return .push
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
        case .requiredTermView(let userCredential): // MARK: - Registration
            RequiredTermView<Router>(userCredential: userCredential)
        case .registrationView(let userCredential):
            RegistrationView<Router>(router.resolver.resolve(RegistrationViewModel.self), userCredential: userCredential)
        case .myView:           // MARK: - My
            MyView<Router>(router.resolver.resolve(MyViewModel.self))
        case .placeShowcaseView(let userId):
            PlaceShowcaseView<Router>(router.resolver.resolve(PlaceShowcaseViewModel.self), userId: userId)
        case .placeReviewView(let place):
            PlaceReviewView(router.resolver.resolve(PlaceReviewViewModel.self), place: place)
        case .profileEditView(let user):
            ProfileEditView<Router>(profileEditViewModel: router.resolver.resolve(ProfileEditViewModel.self), user: user)
        case .myCommunityRecruitingContentListView:
            MyCommunityRecruitingContentListView<Router>(router.resolver.resolve(MyCommunityRecruitingContentListViewModel.self))
        case .myCommunityListView:
            MyCommunityListView<Router>(router.resolver.resolve(MyCommunityListViewModel.self))
        case .myParticipationRequestListView:
            MyParticipationRequestListView<Router>(router.resolver.resolve(MyParticipationRequestListViewModel.self))
        case .blockedListView:
            BlockedListView<Router>(router.resolver.resolve(BlockedListViewModel.self))
        case .reportListView:
            ReportListView<Router>(router.resolver.resolve(ReportListViewModel.self))
        case .notificationSettingsView:
            NotificationSettingsView<Router>()
        case .unregisterView(let user):
            UnregisterView<Router>(router.resolver.resolve(WithdrawalViewModel.self), user: user)
        case .homeView:         // MARK: - Home
            HomeView<Router>(router.resolver.resolve(HomeViewModel.self))
        case .mapArea:
            MapArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placesListArea:
            PlacesListArea<Router>(router.resolver.resolve(HomeViewModel.self))
        case .placeInformationView(let place):
            PlaceInformationView<Router>(router.resolver.resolve(PlaceInformationViewModel.self), place: place)
        case .placeInformationDetailView(let communityRecruitingContentId, let userId):
            PlaceInformationDetailView<Router>(router.resolver.resolve(PlaceInformationDetailViewModel.self), communityRecruitingContentId: communityRecruitingContentId, userId: userId)
        case .placeInformationDetailMakingView(let place, let communityRecruitingContent):
            PlaceInformationDetailMakingView<Router>(router.resolver.resolve(PlaceInformationDetailMakingViewModel.self), place: place, communityRecruitingContent: communityRecruitingContent)
        case .participationRequestListView(let communityRecruitingContent, let userId):
            ParticipationRequestListView<Router>(participationRequestListViewModel: router.resolver.resolve(ParticipationRequestListViewModel.self), communityRecruitingContent: communityRecruitingContent, userId: userId)
        case .notificationView(let userId):
            NotificationView<Router>(router.resolver.resolve(NotificationViewModel.self), userId: userId)
        case .chatView:         // MARK: - Chat
            ChatView<Router>(router.resolver.resolve(ChatViewModel.self))
        case .chatRoomListView:
            ChatRoomListView<Router>()
        case .reportView(let opponentUserId, let isReported):
            ReportView<Router>(router.resolver.resolve(ReportViewModel.self), opponentUserId: opponentUserId, isReported: isReported)
        case .profileDetailView(let opponentUserId):// MARK: - Common
            ProfileDetailView<Router>(router.resolver.resolve(ProfileDetailViewModel.self), opponentUserId: opponentUserId)
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
