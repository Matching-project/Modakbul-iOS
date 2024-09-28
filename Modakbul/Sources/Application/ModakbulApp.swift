import SwiftUI

@main
struct ModakbulApp: App {
    @StateObject private var router = DefaultAppRouter(by: InfrastructureAssembly(),
                                                           DataAssembly(),
                                                           DomainAssembly(),
                                                           PresentationAssembly())
    @StateObject private var networkChecker = NetworkChecker.shared
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(AppStorageKey.isFirstLaunch) private var isFirstLaunch: Bool = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboradingView($isFirstLaunch)
            } else {
                router.view(to: .routerView)
                    .onChange(of: scenePhase) {
                        switch scenePhase {
                        case .active:
                            networkChecker.startMonitoring()
                        default:
                            networkChecker.stopMonitoring()
                        }
                    }
                    .environmentObject(networkChecker)
            }
        }
    }
}
