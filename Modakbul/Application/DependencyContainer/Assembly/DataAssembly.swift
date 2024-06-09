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
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
