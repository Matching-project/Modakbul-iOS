//
//  UnregistrationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/24/24.
//

import SwiftUI

/// 회원 탈퇴를 처리하는 뷰입니다.
struct UnregistrationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: UnregistrationViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @AppStorage(AppStorageKey.provider) private var provider: AuthenticationProvider?
    
    private let user: User
    
    init(_ unregistrationViewModel: UnregistrationViewModel, user: User) {
        self.vm = unregistrationViewModel
        self.user = user
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("잠깐만요!")
                .font(.Modakbul.title)
                .bold()
                        
            Text("더 유익한 모임이 \(user.nickname)님을 기다리고 있어요. 정말 떠나시겠어요?")
                .font(.Modakbul.headline)
                .foregroundStyle(.gray)
            
            Spacer()
            
            FlatButton("남아있기") {
                router.dismiss()
            }
            
            Button {
                vm.unregister(for: user.id)
            } label: {
                Text("그래도 탈퇴하기")
                    .font(.Modakbul.footnote)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.vertical, Constants.vertical)
        // TODO: - SocialLoginRepository.unregister() 에서 처리해주는 로직 구상
        .onChange(of: vm.provider) { _, provider in
            self.provider = provider
            self.userId = Constants.loggedOutUserId
            router.popToRoot()
        }
        .onAppear {
            vm.provider = provider
        }
    }
}

struct UnregisterView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .unregistrationView(user: User()))
    }
}
