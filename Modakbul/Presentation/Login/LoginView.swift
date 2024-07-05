//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func onOpenURL(url: URL) {
        loginUseCase.onOpenURL(url: url)
    }
    
    func loginWithKakaoTalk() {
        Task {
            guard let user = try? await loginUseCase.login(with: .kakao) else { return print("로그인 실패") }
        }
    }
}

struct LoginView<Router: AppRouter>: View where Router.Destination == Route {
    @EnvironmentObject private var router: Router
    @ObservedObject private var loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            appLogo
            
            Spacer()
            
            signInWithKakaoButton
            
            AppleLoginButton()
            
            Button {
                router.route(to: .myView)
            } label: {
                Text("MyView 시트")
            }
            
            Button {
                router.route(to: .loginView)
            } label: {
                Text("LoginView 풀스크린")
            }
            
            Button {
                router.dismiss()
            } label: {
                Text("Dismiss")
            }
            
            Button {
                router.popToRoot()
            } label: {
                Text("PopToRoot")
            }
            
            Button {
                router.alert(for: .warningBeforeSaveAlert,
                             actions: [
                                .destructiveAction("나가기", action: print("나감")),
                                .cancelAction("취소", action: print("안나감"))
                             ])

            } label: {
                Text("저장 전 얼럿")
            }
            
            Button {
                router.alert(for: .participationRequestSuccessAlert,
                             actions: [
                                .defaultAction("확인", action: print("참여 요청하기"))
                             ])

            } label: {
                Text("참여 요청 얼럿")
            }
            
            Button {
                router.alert(for: .warningBeforeSaveAlert,
                             actions: [
                                .cancelAction("취소", action: print("취소")),
                                .destructiveAction("전부 나가기", action: print("채팅방 전부 나가기"))
                             ])

            } label: {
                Text("대화방 전체 삭제 얼럿")
            }

            Spacer()
        }
        .padding()
    }
    
    private var appLogo: some View {
        Image(systemName: "questionmark")
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFit()
    }
    
    private var signInWithKakaoButton: some View {
        Button {
            loginViewModel.loginWithKakaoTalk()
        } label: {
            Text("카카오로 로그인")
        }
        .onOpenURL { url in
            loginViewModel.onOpenURL(url: url)
        }
    }
}
