//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView<Router: AppRouter>: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var router: Router
    @ObservedObject private var loginViewModel: LoginViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = String()
    @AppStorage(AppStorageKey.provider) private var provider: AuthenticationProvider?
    
    init(_ loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            appLogo
            
            VStack {
                signInWithKakaoButton
                signInWithAppleButton
                
                Button {
                    router.dismiss()
                } label: {
                    Text("뒤로 가기")
                        .font(.Modakbul.callout)
                }
            }
        }
        .padding()
    }
    
    private var appLogo: some View {
        Image(.modakbulMain)
            .resizable()
            .scaledToFit()
    }
    
    private var signInWithKakaoButton: some View {
        SignInKakaoButton { result in
            switch result {
            case .success(let email):
                loginViewModel.kakaoLogin(email) {
                    performLogin($0, $1)
                }
                router.dismiss()
            case .failure(let error):
                print(error)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(height: 44)
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
            request.nonce = UUID().uuidString
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                loginViewModel.appleLogin(auth) {
                    performLogin($0, $1)
                }
                router.dismiss()
            case .failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(height: 44)
    }
    
    private func performLogin(_ userId: Int64, _ userNickname: String) {
        guard let userCredential = loginViewModel.userCredential else { return }
        
        if userId == Constants.loggedOutUserId {
            Task { @MainActor in
                router.route(to: .requiredTermView(userCredential: userCredential))
            }
        } else {
            self.userId = Int(userId)
            self.userNickname = userNickname
            self.provider = userCredential.provider
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .loginView)
    }
}
