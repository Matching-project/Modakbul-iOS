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
//        container.register(for: PlaceShowcaseViewModel.self) { resolver in
//            PlaceShowcaseViewModel(placeShowcaseAndReviewUseCase: resolver.resolve(PlaceShowcaseAndReviewUseCase.self))
//        }
        
        // MARK: - Home
        container.register(for: HomeViewModel.self) { resolver in
            HomeViewModel(localMapUseCase: resolver.resolve(LocalMapUseCase.self))
        }
        
        container.register(for: PlaceInformationViewModel.self) { resolver in
            PlaceInformationViewModel()
        }
        
        //        container.register(for: PlaceInformationDetailViewModel.self) { resolver in
        //            PlaceInformationDetailViewModel()
        //        }
        
        container.register(for: PlaceInformationDetailMakingViewModel.self, PlaceInformationDetailMakingViewModel())
        
        container.register(for: ParticipationRequestListViewModel.self) { resolver in
            ParticipationRequestListViewModel()
        }
        
        container.register(for: NotificationViewModel.self, NotificationViewModel())
        
        // MARK: - Chat
        container.register(for: ReportViewModel.self, ReportViewModel())
        
        container.register(for: ChatViewModel.self, ChatViewModel())
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
