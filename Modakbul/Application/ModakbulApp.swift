import SwiftUI

@main
struct ModakbulApp: App {
    @StateObject private var router = DefaultAppRouter(by: InfrastructureAssembly(),
                                                                  DataAssembly(),
                                                                  DomainAssembly(),
                                                                  PresentationAssembly())
    
    var body: some Scene {
        WindowGroup {
            router.view(to: .routerView)
        }
    }
}
