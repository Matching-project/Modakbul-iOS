//
//  InfrastructureAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

final class InfrastructureAssembly: Assembly {
    func assemble(container: any DependencyContainer) {
        container.register(for: DefaultNetworkSessionManager.self, DefaultNetworkSessionManager())
        container.register(for: DefaultNetworkService.self) { resolver in
            DefaultNetworkService(sessionManager: resolver.resolve(DefaultNetworkSessionManager.self))
        }
        container.register(for: DefaultLocationService.self, DefaultLocationService())
    }
    
    func loaded(resolver: any DependencyResolver) {
        // no codes
    }
}
