import SwiftUI

@main
struct ModakbulApp: App {
    @ObservedObject private var router: AppRouter
//    private let assembler: Assembler
    
    init() {
        let container = DefaultDependencyContainer()
        container.register(for: TokenStorage.self, DefaultTokenStorage())
        container.register(for: KakaoLoginManager.self, DefaultKakaoLoginManager())
        container.register(for: AuthorizationService.self) { r in
            DefaultAuthorizationService(kakaoLoginManager: r.resolve(KakaoLoginManager.self))
        }
        container.register(for: NetworkSessionManager.self, DefaultNetworkSessionManager())
        container.register(for: NetworkService.self) { r in
            DefaultNetworkService(sessionManager: r.resolve(NetworkSessionManager.self))
        }
        container.register(for: SocialLoginRepository.self) { r in
            DefaultSocialLoginRepository(
                tokenStorage: r.resolve(TokenStorage.self),
                authorizationService: r.resolve(AuthorizationService.self),
                networkService: r.resolve(NetworkService.self)
            )
        }
        container.register(for: LoginUseCase.self) { r in
            DefaultLoginUseCase(socialLoginRepository: r.resolve(SocialLoginRepository.self))
        }
        container.register(for: LoginViewModel.self) { r in
            LoginViewModel(loginUseCase: r.resolve(LoginUseCase.self))
        }
        container.register(for: LoginView.self) { r in
            LoginView(loginViewModel: r.resolve(LoginViewModel.self))
        }
        
        self.router = AppRouter(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .environmentObject(router)
            }
        }
    }
}
