//
//  PresentationAssembly.swift
//  Modakbul
//
//  Created by Swain Yun on 6/8/24.
//

import Foundation

struct PresentationAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        container.register(for: LoginViewModel.self) { resolver in
            LoginViewModel(userRegistrationUseCase: resolver.resolve(UserRegistrationUseCase.self))
        }
        container.register(for: HomeViewModel.self) { resolver in
            HomeViewModel(localMapUseCase: resolver.resolve(LocalMapUseCase.self))
        }
        
        container.register(for: PlaceShowcaseViewModel.self) { resolver in
            PlaceShowcaseViewModel(localMapUseCase: resolver.resolve(LocalMapUseCase.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
