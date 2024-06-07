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

struct LoginView: View {
    @EnvironmentObject private var router: AppRouter
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

//#Preview {
//    LoginView()
//        .environmentObject(PreviewHelper.shared.router)
//}
