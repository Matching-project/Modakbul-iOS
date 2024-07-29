//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var loginViewModel: LoginViewModel
    
    @State private var isPresented: Bool = false
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            appLogo
            
            VStack {
                signInWithKakaoButton
                
                signInWithAppleButton
            }
        }
        .padding()
    }
    
    private var appLogo: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
    }
    
    private var signInWithKakaoButton: some View {
        SignInKakaoButton { result in
            switch result {
            case .success(let kakaoUser):
                loginViewModel.loginWithKakaoTalk(kakaoUser)
                router.dismiss()
            case .failure(let error):
                print(error)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                loginViewModel.loginWithApple(auth.credential)
            case .failure(let error):
                print(error)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(height: 44)
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .loginView)
    }
}
