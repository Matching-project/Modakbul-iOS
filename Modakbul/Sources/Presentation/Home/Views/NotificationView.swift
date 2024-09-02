//
//  NotificationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import SwiftUI

// TODO: - 명세에 없으나, 토스, 당근 같은 서비스는 당겨서 새로고침(Refreshable) 및 해당 화면으로 이동 지원함.
struct NotificationView<Router: AppRouter>: View {
    @ObservedObject private var vm: NotificationViewModel
    @EnvironmentObject private var router: Router
    @Environment(\.editMode) private var editMode
    
    init(_ notificationViewModel: NotificationViewModel) {
        self.vm = notificationViewModel
    }
    
    var body: some View {
        List(vm.notifications, selection: $vm.multiSelection) { notification in
            Cell(notification)
                .swipeActions(edge: .trailing) {
                    deleteSwipeAction(for: notification)
                }
                .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .navigationModifier(title: "알림") {
            router.dismiss()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if isEditingEnabled {
                    deleteButton
                }
                editButton
            }
        }
    }
    
    private var deleteButton: some View {
        Group {
            if !vm.multiSelection.isEmpty {
                Button("삭제") {
                    vm.deleteSelectedNotifications()
                }
            } else {
                Button("전체삭제") {
                    vm.deleteAllNotifications()
                    toggleEditMode()
                }
            }
        }
    }
    
    private var editButton: some View {
        Button(action: toggleEditMode) {
            Text(editMode?.wrappedValue.isEditing == true ? "확인" : "편집")
        }
        .disabled(vm.notifications.isEmpty)
    }
    
    private var isEditingEnabled: Bool {
        editMode?.wrappedValue.isEditing == true && !vm.notifications.isEmpty
    }
    
    private func deleteSwipeAction(for notification: PushNotification) -> some View {
        Button(role: .destructive) {
            vm.deleteSwipedNotification(notification)
        } label: {
            Label("삭제하기", systemImage: "trash")
        }
    }
    
    private func toggleEditMode() {
        editMode?.wrappedValue = editMode?.wrappedValue.isEditing == true ? .inactive : .active
    }
}

extension NotificationView {
    struct Cell: View {
        private let notification: PushNotification
        @Environment(\.colorScheme) private var colorScheme
        
        init(_ notification: PushNotification) {
            self.notification = notification
        }
        
        var body: some View {
            HStack {
                AsyncImageView(url: notification.imageURL, contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 5) {
                    titleView
                    subtitleView
                }
                .padding(.vertical, 15)
            }
            .padding(.horizontal)
            .background(colorScheme == .dark ? .gray.opacity(0.2) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 4)
        }
        
        private var titleView: some View {
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
        }
        
        private var subtitleView: some View {
            Text(notification.subtitle)
                .foregroundColor(.accent)
                .font(.caption)
        }
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .notificationView)
        }
    }
}
