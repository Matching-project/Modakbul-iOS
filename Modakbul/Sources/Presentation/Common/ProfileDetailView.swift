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
    
    init(profileDetailViewModel: ProfileDetailViewModel) {
        self.vm = profileDetailViewModel
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
    }
    
    private var menuButtonAction: some View {
        Group {
            // TODO: - 차단하기 / 차단해제 토글 필요
            if vm.isBlocked {
                Button {
                    vm.isBlocked.toggle()
                } label: {
                    Text("차단해제")
                }
            } else {
                Button {
                    router.alert(for: .blockUserConfirmation, actions: [
                        .cancelAction("취소") {},
                        .destructiveAction("차단") {
                            vm.isBlocked.toggle()
                        },
                    ])
                } label: {
                    Text("차단하기")
                }
            }
            
            if vm.isRepoerted {
                Button {
                    // TODO: - 신고하기 후 신고내역으로 이동
                    //                    router.route(to: .)
                } label: {
                    Text("신고내역")
                }
            } else {
                Button {
                    router.alert(for: .reportUser, actions: [
                        .cancelAction("취소") {},
                        .destructiveAction("신고") {
                            router.route(to: .reportView(result: $vm.isRepoerted))
                        },
                    ])
                } label: {
                    Text("신고하기")
                }
            }
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

final class ProfileDetailViewModel: ObservableObject {
    var user: User
    @Published var isBlocked: Bool
    @Published var isRepoerted: Bool
    
    // TODO: - isBlocked, isRepoerted 기본값 제거할 것
    init(user: User = PreviewHelper.shared.users.first!,
         isBlocked: Bool = false,
         isRepoerted: Bool = false
    ) {
        self.user = user
        self.isBlocked = isBlocked
        self.isRepoerted = isRepoerted
    }
    
    // TODO: - isBlocked, isReported가 true가 되면 UseCase를 통해 처리하는 func 필요
}

struct ProfileDetailView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .profileDetailView)
        }
    }
}
