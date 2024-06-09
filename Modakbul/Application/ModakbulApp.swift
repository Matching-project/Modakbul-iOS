import SwiftUI

@main
struct ModakbulApp: App {
    @ObservedObject private var router: AppRouter
    
    init() {
        let assembler = Assembler(by: InfrastructureAssembly(),
                                  DataAssembly(),
                                  DomainAssembly(),
                                  PresentationAssembly())
        self.router = AppRouter(assembler: assembler)
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView(router: router) {
                ContentView()
                    .environmentObject(router)
            }
        }
    }
}
