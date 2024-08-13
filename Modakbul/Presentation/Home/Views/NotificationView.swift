//
//  NotificationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import SwiftUI

// TODO: - 토스, 당근 같은 서비스는 당겨서 새로고침(Refreshable) 및 해당 화면으로 이동 지원함.
// 다만, 명세에는 언급되어 있지 않음.
struct NotificationView<Router: AppRouter>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: NotificationViewModel

    init(_ notificationViewModel: NotificationViewModel) {
        self.vm = notificationViewModel
    }
    
    var body: some View {
        List(vm.notifications) { notification in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .foregroundColor(.accent)
                        .bold()
                    Text(notification.titlePostfix)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .topTrailing) {
                    Text(notification.timestamp)
                        .font(.caption)
                        .bold()
                }
                
                Text(notification.subtitle)
                    .foregroundColor(.accent)
                    .font(.caption)
            }
            .padding(.leading, 10)
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 1)
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton {
            router.dismiss()
        })
        .navigationTitle("알림")
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .notificationView)
    }
}

final class NotificationViewModel: ObservableObject {
    // TODO: - UseCase 연결 필요
//    private let notificationUseCase: NotificationUseCase
    
    var notifications: [PushNotification] = PreviewHelper.shared.notifications
}
