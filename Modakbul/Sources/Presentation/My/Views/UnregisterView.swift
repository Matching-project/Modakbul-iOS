//
//  UnregisterView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/24/24.
//

import SwiftUI

/// 회원 탈퇴를 처리하는 뷰입니다.
struct UnregisterView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: WithdrawalViewModel
    private let user: User
    
    init(_ withdrawalViewModel: WithdrawalViewModel, user: User) {
        self.vm = withdrawalViewModel
        self.user = user
    }
    
    var body: some View {
        VStack {
            Text("잠깐만요!")
                .font(.Modakbul.title)
                .bold()
            
            Text("더 유익한 모임이 \(user.nickname)님을 기다리고 있어요. 정말 떠나시겠어요?")
                .font(.Modakbul.headline)
                .foregroundStyle(.gray)
            
            FlatButton("남아있기") {
                router.dismiss()
            }
            
            Button {
                // TODO: - 탈퇴
            } label: {
                Text("그래도 탈퇴하기")
                    .font(.Modakbul.headline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

final class WithdrawalViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
//    @MainActor
//    func unregister(user: User) {
//        Task {
//            do {
//                try await userRegistrationUseCase.unregister(userId: user.id, provider: user.provider!)
//            } catch {
//                print(error)
//            }
//        }
//    }
}

//struct WithdrawalView_Preview: PreviewProvider {
//    static var previews: some View {
////        router.view(to: .)
//    }
//}

