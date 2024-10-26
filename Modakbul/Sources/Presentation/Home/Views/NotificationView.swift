//
//  NotificationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import SwiftUI

struct NotificationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: NotificationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.editMode) private var editMode
    
    private let userId: Int64
    
    init(_ notificationViewModel: NotificationViewModel,
         userId: Int64
    ) {
        self.vm = notificationViewModel
        self.userId = userId
    }
    
    var body: some View {
        List(vm.notifications.reversed(), selection: $vm.multiSelection) { notification in
            Cell(notification)
                .swipeActions(edge: .trailing) {
                    deleteSwipeAction(for: notification)
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    vm.readNotification(userId: userId, notification)
                    if let route = notification.type.route {
                        router.route(to: route)
                    }
                }
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
        .onAppear {
            vm.fetchNotifications(userId: userId)
        }
        .refreshable {
            vm.fetchNotifications(userId: userId)
        }
    }
    
    private var deleteButton: some View {
        Group {
            if !vm.multiSelection.isEmpty {
                Button("삭제") {
                    vm.removeSelectedNotifications(userId: userId)
                }
            } else {
                Button("전체삭제") {
                    vm.removeAllNotifications(userId: userId)
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
            vm.removeSwipedNotification(userId: userId, notification)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 15)
            }
            .padding(.horizontal)
            .background(
                colorScheme == .dark
                    ? (notification.isRead ? Color.gray.opacity(0.2) : Color.gray.opacity(0.45))
                    : (notification.isRead ? Color.gray.opacity(0.2) : Color.accent.opacity(0.45)))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        
        private var titleView: some View {
            HStack {
                Text(notification.title)
                    .lineLimit(2)
                    .foregroundColor(.accent)
                    .bold()
                
                Spacer()
                
                Text(notification.timestamp)
                    .font(.Modakbul.caption)
                    .bold()
            }
        }
        
        private var subtitleView: some View {
            Text(notification.subtitle)
                .foregroundColor(.accent)
                .font(.Modakbul.caption)
        }
    }
}
