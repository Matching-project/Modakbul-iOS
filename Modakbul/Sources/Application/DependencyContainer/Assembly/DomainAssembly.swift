//
//  DomainAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct DomainAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        // MARK: - Login
        container.register(for: UserRegistrationUseCase.self) { resolver in
            DefaultUserRegistrationUseCase(socialLoginRepository: resolver.resolve(SocialLoginRepository.self))
        }
        
        // MARK: - Registartion
        
        // MARK: - My
        container.register(for: PlaceShowcaseAndReviewUseCase.self) { resolver in
            DefaultPlaceShowcaseAndReviewUseCase(placesRepository: resolver.resolve(PlacesRepository.self))
        }
        
        // MARK: - Home
        container.register(for: LocalMapUseCase.self) { resolver in
            DefaultLocalMapUseCase(placesRepository: resolver.resolve(PlacesRepository.self))
        }
        
        container.register(for: CommunityUseCase.self) { resolver in
            DefaultCommunityUseCase(communityRepository: resolver.resolve(CommunityRepository.self))
        }
        
        container.register(for: MatchingUseCase.self) { resolver in
            DefaultMatchingUseCase(matchingRepository: resolver.resolve(MatchingRepository.self))
        }
        
        // MARK: - Notification
        container.register(for: NotificationUseCase.self) { resolver in
            DefaultNotificationUseCase(notificationRepository: resolver.resolve(NotificationRepository.self))
        }
        
        
//        container.register(for: UserBusinessUseCase.self) { resolver in
//            <#code#>
//        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
