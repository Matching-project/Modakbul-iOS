//
//  DataAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct DataAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        container.register(for: SocialLoginRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let authorizationService = resolver.resolve(AuthorizationService.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultSocialLoginRepository(tokenStorage: tokenStorage, 
                                                authorizationService: authorizationService,
                                                networkService: networkService)
        }
        
        container.register(for: PlacesRepository.self) { resolver in
            DefaultPlacesRepository(networkService: resolver.resolve(NetworkService.self))
        }
        
        container.register(for: CoordinateRepository.self) { resolver in
            DefaultCoordinateRepository(locationService: resolver.resolve(LocationService.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
