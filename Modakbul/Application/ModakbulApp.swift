import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct ModakbulApp: App {
    @ObservedObject private var router: AppRouter
    private let assembler: Assembler
    
    init() {
        self.router = AppRouter()
        self.assembler = Assembler(by: InfrastructureAssembly())
        
        guard let appKey = Bundle.main.getAPIKey(provider: AuthenticationProvider.kakao) else {
            return
        }
        KakaoSDK.initSDK(appKey: appKey)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .environmentObject(router)
                    .onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            AuthController.handleOpenUrl(url: url)
                            
                        }
                    })
            }
        }
    }
}
