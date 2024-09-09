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
        // TODO: - 회원가입시 MyViewModel에 유저정보 주입 필요
        container.register(for: MyViewModel.self, MyViewModel())
        
        container.register(for: PlaceShowcaseViewModel.self) { resolver in
            PlaceShowcaseViewModel(placeShowcaseAndReviewUseCase: resolver.resolve(PlaceShowcaseAndReviewUseCase.self))
        }
        
        // TODO: - UseCase 필요
        container.register(for: ProfileEditViewModel.self) { resolver in
            ProfileEditViewModel(userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self))
        }
        
        // TODO: - UseCase 필요
        container.register(for: NotificationSettingsViewModel.self, NotificationSettingsViewModel())
        
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
                                            notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        container.register(for: PlaceInformationDetailMakingViewModel.self) { resolver in
            PlaceInformationDetailMakingViewModel(communityUseCase: resolver.resolve(CommunityUseCase.self))
        }
        
        container.register(for: ParticipationRequestListViewModel.self) { resolver in
            ParticipationRequestListViewModel(matchingUseCase: resolver.resolve(MatchingUseCase.self))
        }
        
        container.register(for: NotificationViewModel.self) { resolver in
            NotificationViewModel(notificationUseCase: resolver.resolve(NotificationUseCase.self))
        }
        
        // MARK: - Chat
        container.register(for: ReportViewModel.self, ReportViewModel())
        
        container.register(for: ChatViewModel.self, ChatViewModel())
        
        // MARK: - Common
        container.register(for: ProfileDetailViewModel.self, ProfileDetailViewModel())
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
