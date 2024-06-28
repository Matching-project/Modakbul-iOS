//
//  InfrastructureAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct InfrastructureAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        // Network
        container.register(for: NetworkSessionManager.self, DefaultNetworkSessionManager())
        container.register(for: NetworkSocketManager.self, DefaultNetworkSocketManager())
        container.register(for: NetworkService.self) { resolver in
            DefaultNetworkService(sessionManager: resolver.resolve(NetworkSessionManager.self),
                                  socketManager: resolver.resolve(NetworkSocketManager.self))
        }
        
        // OAuth
        container.register(for: KakaoLoginManager.self, DefaultKakaoLoginManager())
        container.register(for: AuthorizationService.self) { resolver in
            DefaultAuthorizationService(kakaoLoginManager: resolver.resolve(KakaoLoginManager.self))
        }
        
        // Location
        container.register(for: LocationService.self, DefaultLocationService())
        container.register(for: LocalMapService.self, DefaultLocalMapService())
        
        // Storages
        container.register(for: TokenStorage.self, DefaultTokenStorage())
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
