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
