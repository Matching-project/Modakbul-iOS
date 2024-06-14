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
        container.register(for: NetworkService.self) { resolver in
            DefaultNetworkService(sessionManager: resolver.resolve(NetworkSessionManager.self))
        }
        
        // OAuth
        container.register(for: KakaoLoginManager.self, DefaultKakaoLoginManager())
        container.register(for: AuthorizationService.self) { resolver in
            DefaultAuthorizationService(kakaoLoginManager: resolver.resolve(KakaoLoginManager.self))
        }
        
        // Location
        container.register(for: LocationService.self, DefaultLocationService())
        container.register(for: LocalMapService.self) { resolver in
            DefaultLocalMapService(locationService: resolver.resolve(LocationService.self))
        }
        
        // Storages
        container.register(for: TokenStorage.self, DefaultTokenStorage())
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
