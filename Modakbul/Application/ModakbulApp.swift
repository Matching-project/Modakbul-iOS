import SwiftUI

@main
struct ModakbulApp: App {
    @StateObject private var router = DefaultAppRouter(by: InfrastructureAssembly(),
                                                                  DataAssembly(),
                                                                  DomainAssembly(),
                                                                  PresentationAssembly())
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch == true {
                OnboradingView($isFirstLaunch)
            } else {
                router.view(to: .routerView)
            }
        }
    }
}
