import SwiftUI

@main
struct ModakbulApp: App {
    @StateObject private var router = DefaultAppRouter(by: InfrastructureAssembly(),
                                                           DataAssembly(),
                                                           DomainAssembly(),
                                                           PresentationAssembly())
    @AppStorage(AppStorageKey.isFirstLaunch) private var isFirstLaunch: Bool = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
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
