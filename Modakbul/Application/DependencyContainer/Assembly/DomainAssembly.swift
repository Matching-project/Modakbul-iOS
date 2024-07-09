//
//  DomainAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct DomainAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        container.register(for: LoginUseCase.self) { resolver in
            DefaultLoginUseCase(socialLoginRepository: resolver.resolve(SocialLoginRepository.self))
        }
        
        container.register(for: FetchPlacesUseCase.self) { resolver in
            DefaultFetchPlacesUseCase(placesRepository: resolver.resolve(PlacesRepository.self))
        }
        
        container.register(for: UpdateCoordinateUseCase.self) { resolver in
            DefaultUpdateCoordinateUseCase(placesRepository: resolver.resolve(PlacesRepository.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
