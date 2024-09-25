//
//  NotificationSettingsView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/29/24.
//

import SwiftUI

struct NotificationSettingsView<Router: AppRouter>: View {
    @AppStorage(AppStorageKey.PushNotification.isRequestNotificationOn.description) private var isRequestNotificationOn: Bool = true
    @AppStorage(AppStorageKey.PushNotification.isRequestAcceptedNotificationOn.description) private var isRequestAcceptedNotificationOn: Bool = true
    @AppStorage(AppStorageKey.PushNotification.isChatNotificationOn.description) private var isChatNotificationOn: Bool = true
    @AppStorage(AppStorageKey.PushNotification.isMemberLeaveNotificationOn.description) private var isMemberLeaveNotificationOn: Bool = true
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        VStack(spacing: 25) {
            Cell(title: "참여 요청 알림", subtitle: "새로운 참여 요청이 오면 알림을 받습니다.", isOn: $isRequestNotificationOn)
            Cell(title: "참여 요청 수락 알림", subtitle: "참여 요청이 수락되면 알림을 받습니다.", isOn: $isRequestAcceptedNotificationOn)
            Cell(title: "채팅 알림", subtitle: "새로운 채팅이 오면 알림을 받을 수 있습니다.", isOn: $isChatNotificationOn)
            Cell(title: "팀원 탈퇴 알림", subtitle: "방장일 때 모임의 팀원이 나가면 알림을 받습니다.", isOn: $isMemberLeaveNotificationOn)
            
            Spacer()
        }
        .padding(.horizontal, Constants.horizontal)
        .navigationTitle("알림 설정")
    }
}

extension NotificationSettingsView {
    struct Cell: View {
        let title: String
        let subtitle: String
        @Binding var isOn: Bool
        
        var body: some View {
            Toggle(isOn: $isOn) {
                Text(title)
                
                Text(subtitle)
                    .font(.Modakbul.footnote)
                    .foregroundStyle(.accent)
            }
            .toggleStyle(SwitchToggleStyle(tint: .accent))
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        router.view(to: .notificationSettingsView)
    }
}
