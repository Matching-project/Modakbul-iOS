import SwiftUI

@main
struct ModakbulApp: App {
    @StateObject private var router = DefaultAppRouter(by: InfrastructureAssembly(),
                                                                  DataAssembly(),
                                                                  DomainAssembly(),
                                                                  PresentationAssembly())
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch == true {
                OnboradingView($isFirstLaunch)
            } else {
                router.view(to: .routerView)
            }
        }
    }
    
    private func requestNotificationPermission() {
         let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
             if granted {
                 DispatchQueue.main.async {
                     UIApplication.shared.registerForRemoteNotifications()
                 }
             } else {
                 // TODO: - 권한 요청이 거부된 경우 처리
                 print("Push Notification permission denied: \(String(describing: error))")
             }
         }
     }
}

// MARK: - APNs 코드
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("Device Token:\(deviceTokenString)")
        
        // TODO: -
//        self.sendDeviceTokenToServer(data: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register Push Notification: \(error)")
    }
}
