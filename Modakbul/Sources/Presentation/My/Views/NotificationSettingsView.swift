//
//  NotificationSettingsView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/29/24.
//

import SwiftUI

struct NotificationSettingsView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: NotificationSettingsViewModel
    
    init(notificationSettingsViewModel: NotificationSettingsViewModel) {
        self.vm = notificationSettingsViewModel
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Cell(title: "채팅 알림", subtitle: "새로운 채팅이 오면 알림을 받을 수 있습니다.", isOn: $vm.isChatNotificationOn)
            Cell(title: "참여 요청 수락 알림", subtitle: "참여 요청이 수락되면 알림을 받습니다.", isOn: $vm.isRequestAcceptedNotificationOn)
            Cell(title: "참여 요청 알림", subtitle: "새로운 참여 요청이 오면 알림을 받습니다.", isOn: $vm.isRequestNotificationOn)
            Cell(title: "팀원 탈퇴 알림", subtitle: "방장일 때 모임의 팀원이 나가면 알림을 받습니다.", isOn: $vm.isMemberLeaveNotificationOn)
            
            Spacer()
        }
        .padding(.horizontal, Constants.horizontal)
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
                    .font(.footnote)
                    .foregroundStyle(.accent)
            }
            .toggleStyle(SwitchToggleStyle(tint: .accent))
        }
    }
}

final class NotificationSettingsViewModel: ObservableObject {
    @Published var isChatNotificationOn: Bool
    @Published var isRequestAcceptedNotificationOn: Bool
    @Published var isRequestNotificationOn: Bool
    @Published var isMemberLeaveNotificationOn: Bool
    
    // TODO: - 로컬 or 서버에서 설정값을 저장해야 함
    init(isChatNotificationOn: Bool = true,
         isRequestAcceptedNotificationOn: Bool = true,
         isRequestNotificationOn: Bool = true,
         isMemberLeaveNotificationOn: Bool = true
    ) {
        self.isChatNotificationOn = isChatNotificationOn
        self.isRequestAcceptedNotificationOn = isRequestAcceptedNotificationOn
        self.isRequestNotificationOn = isRequestNotificationOn
        self.isMemberLeaveNotificationOn = isMemberLeaveNotificationOn
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        router.view(to: .notificationSettingsView)
    }
}
