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
        
        // TODO: - Repo 연결 예정
        container.register(for: NotificationUseCase.self, )
        
        
//        container.register(for: UserBusinessUseCase.self) { resolver in
//            <#code#>
//        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
