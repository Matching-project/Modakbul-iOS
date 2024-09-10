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
    @AppStorage(AppStorageKey.userId) private var userId: Int = -1
    
    private let opponentUserId: Int64
    
    init(_ profileDetailViewModel: ProfileDetailViewModel, opponentUserId: Int64) {
        self.vm = profileDetailViewModel
        self.opponentUserId = opponentUserId
    }
    
    var body: some View {
        VStack {
            AsyncImageView(url: vm.user.imageURL, contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(.circle)
                .padding(.bottom, 40)
            
            Cell(title: "닉네임", content: vm.user.nickname)
            Cell(title: "성별", content: vm.user.gender.description)
            Cell(title: "직업", content: vm.user.job.description)
            Cell(title: "카테고리", content: vm.user.categoriesOfInterest.description)
            
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
            vm.block(userId: Int64(userId), opponentUserId: opponentUserId)
        } label: {
            Text("차단해제")
        }
    }
    
    private var blockButton: some View {
        Button {
            router.alert(for: .blockUserConfirmation, actions: [
                .cancelAction("취소") {},
                .destructiveAction("차단") {
                    vm.unblock(userId: Int64(userId), blockId: opponentUserId)
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
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 100, alignment: .leading)
                
                Text(content)
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ProfileDetailView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .profileDetailView(opponentUserId: -1))
        }
    }
}
