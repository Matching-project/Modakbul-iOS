//
//  PresentationAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct PresentationAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        // MARK: - Login
        container.register(for: LoginViewModel.self) { resolver in
            LoginViewModel(userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self))
        }
        
        // MARK: - Registration
        container.register(for: RegistrationViewModel.self) { resolver in
            RegistrationViewModel(userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self))
        }
        
        // MARK: - My
        container.register(for: MyViewModel.self) { resolver in
            MyViewModel(
                userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self),
                userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self)
            )
        }
        
        container.register(for: PlaceShowcaseViewModel.self) { resolver in
            PlaceShowcaseViewModel(placeShowcaseAndReviewUseCase: resolver.resolve(PlaceShowcaseAndReviewUseCase.self))
        }
        
        container.register(for: PlaceReviewViewModel.self) { resolver in
            PlaceReviewViewModel(placeShowcaseAndReviewUseCase: resolver.resolve(PlaceShowcaseAndReviewUseCase.self))
        }
        
        container.register(for: ProfileEditViewModel.self) { resolver in
            ProfileEditViewModel(
                userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self),
                userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self)
            )
        }
        
        container.register(for: MyCommunityRecruitingContentListViewModel.self) { resolver in
            MyCommunityRecruitingContentListViewModel(communityUseCase: resolver.resolve(CommunityUseCase.self))
        }
        
        container.register(for: MyCommunityListViewModel.self) { resolver in
            MyCommunityListViewModel(matchingUseCase: resolver.resolve(MatchingUseCase.self))
        }
        
        container.register(for: MyParticipationRequestListViewModel.self) { resolver in
            MyParticipationRequestListViewModel(matchingUseCase: resolver.resolve(MatchingUseCase.self))
        }
        
        container.register(for: BlockedListViewModel.self) { resolver in
            BlockedListViewModel(userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self))
        }
        
        container.register(for: ReportListViewModel.self) { resolver in
            ReportListViewModel(userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self))
        }
        
        container.register(for: UnregistrationViewModel.self) { resolver in
            UnregistrationViewModel(userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self))
        }
        
        // MARK: - Home
        container.register(for: HomeViewModel.self) { resolver in
            HomeViewModel(localMapUseCase: resolver.resolve(LocalMapUseCase.self),
                          notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        container.register(for: PlaceInformationViewModel.self) { resolver in
            PlaceInformationViewModel(communityUseCase: resolver.resolve(CommunityUseCase.self))
        }
        
        container.register(for: PlaceInformationDetailViewModel.self) { resolver in
            PlaceInformationDetailViewModel(communityUseCase: resolver.resolve(CommunityUseCase.self), 
                                            matchingUseCase: resolver.resolve(MatchingUseCase.self),
                                            notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        container.register(for: PlaceInformationDetailMakingViewModel.self) { resolver in
            PlaceInformationDetailMakingViewModel(communityUseCase: resolver.resolve(CommunityUseCase.self))
        }
        
        container.register(for: ParticipationRequestListViewModel.self) { resolver in
            ParticipationRequestListViewModel(matchingUseCase: resolver.resolve(MatchingUseCase.self),
                                              notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        container.register(for: NotificationViewModel.self) { resolver in
            NotificationViewModel(notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        // MARK: - Chat
        container.register(for: ReportViewModel.self) { resolver in
            ReportViewModel(userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self))
        }
        
        container.register(for: ChatViewModel.self) { resolver in
            ChatViewModel(chatUseCase: resolver.resolve(ChatUseCase.self))
        }
        
        container.register(for: ChatRoomListViewModel.self) { resolver in
            ChatRoomListViewModel(chatUseCase: resolver.resolve(ChatUseCase.self))
        }
        
        // MARK: - Common
        container.register(for: ProfileDetailViewModel.self) { resolver in
            ProfileDetailViewModel(userBusinessUseCase: resolver.resolve(UserBusinessUseCase.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
