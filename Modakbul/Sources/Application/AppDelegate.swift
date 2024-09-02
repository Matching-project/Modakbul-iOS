//
//  AppDelegate.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/2/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

// MARK: - Firebase Quickstart Samples for iOS by Google: https://github.com/firebase/quickstart-ios/blob/14c812998f4fea0338a09bfec877470a1358ff80/messaging/MessagingExampleSwift/AppDelegate.swift#L116-L159
final class AppDelegate: UIResponder, UIApplicationDelegate {
    // TODO: - 메세지 식별시 사용 예정 (푸시 알림 타입에 따라 화면 분기 필요)
    //    let gcmMessageIDKey = "gcm.message_id"
    
    // MARK: - FCM 초기화
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UNUserNotificationCenter.current().delegate = self
        
        Task { @MainActor in
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print(error)
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: - 푸시 알림 등록 실패시
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK: - foreground 푸시 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
    
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any] {
            let title = alert["title"] as? String ?? "제목 없음"
            let body = alert["body"] as? String ?? "내용 없음"
            
//            print("🔴 Recevied PushNotification from Foreground")
//            print(userInfo)
            
            // TODO: - 백엔드에 의해 imageURL, timestamp, type 수정 예정
            NotificationManager.shared.notifications.append(PushNotification(imageURL: PreviewHelper.url1, title: title, subtitle: body, timestamp: "방금", type: .request))
        }
        
        // MARK: - .badge, .sound: FCM에서 별도 옵션 필요
        // TODO: - .list: foreground에서 푸시 수신시, 푸시 알림이 알림센터에 누적되어야 하나 말아야 하나?
        return [[.banner, .badge, .sound]]
    }
    
    // MARK: - Foreground 또는 background에서 푸시 수신 후, 사용자가 노티를 클릭하여 앱을 열었을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        
        let userInfo = response.notification.request.content.userInfo
        
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
//        print("🔴 Touched PushNotification")
//        print(userInfo)
        
        NotificationManager.shared.lastNotification?.isTouched = true
    }
}

// MARK: - FCM 토큰 수신
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
