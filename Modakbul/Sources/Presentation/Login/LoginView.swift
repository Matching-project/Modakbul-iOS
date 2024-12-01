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
            case .success(let account):
                loginViewModel.kakaoLogin(account) {
                    performLogin($0)
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
                    performLogin($0)
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
    
    @MainActor
    private func performLogin(_ result: Result<(Int64, String), APIError>) {
        guard let userCredential = loginViewModel.userCredential else { return }
        
        switch result {
        case .success(let success):
            self.userId = Int(success.0)
            self.userNickname = success.1
            self.provider = userCredential.provider
        case .failure(let error):
            if error == .userNotExist {
                router.route(to: .requiredTermView(userCredential: userCredential))
            } else {
                router.alert(for: .temporalErrorOccurred, actions: [
                    .defaultAction("재시도", action: {
                        performLogin(result)
                    }),
                    .defaultAction("취소", action: {
                        router.dismiss()
                    })
                ])
            }
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .loginView)
    }
}
