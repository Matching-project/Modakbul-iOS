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
        container.register(for: SocketManager.self, DefaultSocketManager())
        container.register(for: NetworkService.self, DefaultNetworkService())
        
        // LocalMap
        container.register(for: LocalMapService.self, DefaultLocalMapService())
        
        // Location
        container.register(for: LocationService.self, DefaultLocationService())
        
        // Chat
//        container.register(for: ChatService.self) { resolver in
//            DefaultChatService(socketManager: resolver.resolve(SocketManager.self))
//        }
        
        // Storages
        container.register(for: TokenStorage.self, DefaultTokenStorage())
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
