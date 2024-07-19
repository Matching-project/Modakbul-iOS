//
//  DataAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct DataAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        // SocialLoginRepository
        container.register(for: SocialLoginRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let authorizationService = resolver.resolve(AuthorizationService.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultSocialLoginRepository(tokenStorage: tokenStorage, 
                                                authorizationService: authorizationService,
                                                networkService: networkService)
        }
        
        // PlacesRepository
        container.register(for: PlacesRepository.self) { resolver in
            let networkService = resolver.resolve(NetworkService.self)
            let localMapService = resolver.resolve(LocalMapService.self)
            let locationService = resolver.resolve(LocationService.self)
            return DefaultPlacesRepository(networkService: networkService,
                                    localMapService: localMapService,
                                    locationService: locationService)
        }
        
        // ChatRepository
        container.register(for: ChatRepository.self) { resolver in
            let chatService = resolver.resolve(ChatService.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultChatRepository(chatService: chatService,
                                         networkService: networkService)
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
