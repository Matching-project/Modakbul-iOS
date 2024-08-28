//
//  DomainAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct DomainAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        container.register(for: LocalMapUseCase.self) { resolver in
            DefaultLocalMapUseCase(placesRepository: resolver.resolve(PlacesRepository.self))
        }
        
//        container.register(for: PlaceShowcaseAndReviewUseCase.self) { resolver in
//            DefaultPlace
//        }
        
//        container.register(for: UserBusinessUseCase.self) { resolver in
//            <#code#>
//        }
        
        container.register(for: UserRegistrationUseCase.self) { resolver in
            DefaultUserRegistrationUseCase(socialLoginRepository: resolver.resolve(SocialLoginRepository.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
