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
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultSocialLoginRepository(tokenStorage: tokenStorage,
                                                networkService: networkService)
        }
        
        // PlacesRepository
        container.register(for: PlacesRepository.self) { resolver in
            let networkService = resolver.resolve(NetworkService.self)
            let localMapService = resolver.resolve(LocalMapService.self)
            let locationService = resolver.resolve(LocationService.self)
            let tokenStorage = resolver.resolve(TokenStorage.self)
            return DefaultPlacesRepository(networkService: networkService,
                                           localMapService: localMapService,
                                           locationService: locationService,
                                           tokenStorage: tokenStorage)
        }
        
        // ChatRepository
        container.register(for: ChatRepository.self) { resolver in
//            let chatService = resolver.resolve(ChatService.self)
            let networkService = resolver.resolve(NetworkService.self)
            let tokenStorage = resolver.resolve(TokenStorage.self)
            return DefaultChatRepository(chatService: chatService,
                                         networkService: networkService,
                                         tokenStorage: tokenStorage)
        }
        
        // NotificationRepository
        container.register(for: NotificationRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultNotificationRepository(tokenStorage: tokenStorage, networkService: networkService)
        }
        
        // CommunityRepository
        container.register(for: CommunityRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultCommunityRepository(tokenStorage: tokenStorage, networkService: networkService)
        }
        
        // MatchingRepository
        container.register(for: MatchingRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultMatchingRepository(tokenStorage: tokenStorage, networkService: networkService)
        }
        
        // UserManagementRepository
        container.register(for: UserManagementRepository.self) { resolver in
            let tokenStorage = resolver.resolve(TokenStorage.self)
            let networkService = resolver.resolve(NetworkService.self)
            return DefaultUserManagementRepository(tokenStorage: tokenStorage, networkService: networkService)
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
