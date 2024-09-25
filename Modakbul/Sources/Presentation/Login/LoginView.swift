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
                
                Button {
                    router.dismiss()
                } label: {
                    Text("뒤로 가기")
                        .font(.Modakbul.callout)
                }
            }
        }
        .padding()
        .onReceive(loginViewModel.$userId) { userId in
            guard let id = userId else { return }
            self.userId = Int(id)
            
            if id == Constants.loggedOutUserId {
                router.dismiss()
                
                switch loginViewModel.selectedProvider {
                case .apple:
                    router.route(to: .requiredTermView(userCredential: .init(provider: .apple, authorizationCode: loginViewModel.authorizationCode)))
                case .kakao:
                    router.route(to: .requiredTermView(userCredential: .init(provider: .kakao, email: loginViewModel.email)))
                case .none:
                    break
                }
            }
        }
    }
    
    private var appLogo: some View {
        Image(scheme == .dark ? .modakbulMainDark : .modakbulMainLight)
            .resizable()
            .scaledToFit()
    }
    
    private var signInWithKakaoButton: some View {
        SignInKakaoButton { result in
            switch result {
            case .success(let email):
                loginViewModel.kakaoLogin(email)
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
                guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
                      let authorizationCode = appleIDCredential.authorizationCode else {
                    return print("애플 아이디로 로그인만 지원함")
                }
                
                loginViewModel.appleLogin(authorizationCode)
            case .failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(height: 44)
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .loginView)
    }
}
