//
//  ProfileDetailView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/29/24.
//

import SwiftUI

struct ProfileDetailView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ProfileDetailViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    private let opponentUserId: Int64
    
    init(_ profileDetailViewModel: ProfileDetailViewModel, opponentUserId: Int64) {
        self.vm = profileDetailViewModel
        self.opponentUserId = opponentUserId
    }
    
    var body: some View {
        VStack {
            AsyncImageView(
                url: vm.presentedUser?.imageURL,
                contentMode: .fill,
                maxWidth: 200,
                maxHeight: 200,
                clipShape: .circle
            )
            
            Spacer()
            
            Cell(title: "닉네임", content: vm.presentedUser?.nickname ?? "-")
            Cell(title: "성별", content: vm.presentedUser?.gender.description ?? "-")
            Cell(title: "직업", content: vm.presentedUser?.job.description ?? "-")
            Cell(title: "카테고리", content: vm.presentedUser?.categoriesOfInterest.description ?? "-")
            
            Spacer()
        }
        .padding(.horizontal, Constants.horizontal)
        .navigationModifier {
            router.dismiss()
        } menuButtonAction: {
            menuButtonAction
        }
        .task {
            await vm.configureView(userId: Int64(userId), opponentUserId: opponentUserId)
        }
    }
    
    private var menuButtonAction: some View {
        Group {
            if vm.isBlocked {
                unBlockButton
            } else {
                blockButton
            }
            
            if vm.isReported {
                reportListButton
            } else {
                reportButton
            }
        }
    }
    
    private var unBlockButton: some View {
        Button {
            vm.unblock(userId: Int64(userId))
        } label: {
            Text("차단해제")
        }
    }
    
    private var blockButton: some View {
        Button {
            router.alert(for: .blockUserConfirmation, actions: [
                .cancelAction("취소") {},
                .destructiveAction("차단") {
                    vm.block(userId: Int64(userId), opponentUserId: opponentUserId)
                },
            ])
        } label: {
            Text("차단하기")
        }
    }
    
    private var reportListButton: some View {
        Button {
            router.route(to: .reportListView)
        } label: {
            Text("신고내역")
        }
    }
    
    private var reportButton: some View {
        Button {
            router.alert(for: .reportUser, actions: [
                .cancelAction("취소") {},
                .destructiveAction("신고") {
                    router.route(to: .reportView(opponentUserId: opponentUserId,
                                                 isReported: $vm.isReported))
                },
            ])
        } label: {
            Text("신고하기")
        }
    }
}

extension ProfileDetailView {
    struct Cell: View {
        let title: String
        let content: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.Modakbul.title2)
                    .bold()
                    .frame(maxWidth: 100, alignment: .leading)
                
                Text(content)
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
