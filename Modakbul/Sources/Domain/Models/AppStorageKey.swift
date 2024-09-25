//
//  AppStorageKey.swift
//  Modakbul
//
//  Created by Swain Yun on 9/6/24.
//

import Foundation

/*
 AppStorage의 키로 사용되는 항목들 입니다.
 */
struct AppStorageKey {
    /// 최초 로그인 여부를 의미합니다.
    static let isFirstLaunch: String = "isFirstLaunch"
    /// 최근 로그인한 아이디를 의미합니다.
    static let userId: String = "userId"
    /// 최근 로그인한 OAuth를 의미합니다.
    static let provider: String = "provider"
    
    /// 알림 설정 값입니다.
    /// - WARNING: 값 변경시 `PushNotification.ShowingType.description`도 같이 동기화 해야합니다.
    enum PushNotification: CaseIterable {
        case isRequestNotificationOn
        case isRequestAcceptedNotificationOn
        case isChatNotificationOn
        case isMemberLeaveNotificationOn
        
        var description: String {
            switch self {
            case .isRequestNotificationOn: "requestParticipation"
            case .isRequestAcceptedNotificationOn: "acceptParticipation"
            case .isChatNotificationOn: "newChat"
            case .isMemberLeaveNotificationOn: "exitParticipation"
            }
        }
    }
}
