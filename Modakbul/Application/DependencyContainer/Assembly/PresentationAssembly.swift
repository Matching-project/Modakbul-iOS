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
            LoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self))
        }
        container.register(for: HomeViewModel.self) { resolver in
            HomeViewModel(placesRepository: resolver.resolve(PlacesRepository.self))
        }
    }
    
    func loaded(resolver: DependencyResolver) {
        //
    }
}
