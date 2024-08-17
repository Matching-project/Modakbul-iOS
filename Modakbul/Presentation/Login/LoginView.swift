//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    func onOpenURL(url: URL) {
        userRegistrationUseCase.onOpenURL(url: url)
    }
    
    @MainActor
        func loginWithKakaoTalk() {
            Task {
                do {
                    let user = try await userRegistrationUseCase.login(with: .kakao)
                } catch {
                    print(error)
                }
            }
        }
}

struct LoginView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var loginViewModel: LoginViewModel
    
    @State private var isPresented: Bool = false
    let data: (title: String, message: String) = ("타이틀", "내용")
    
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
                router.route(to: .reportView)
            } label: {
                Text("신고뷰")
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
                router.confirmationDialog(for: .userReportOrBlockConfirmationDialog,
                                          actions: [
                                            .defaultAction("신고하기", action: router.alert(for: .reportUserConfirmationAlert(user: "사용자 이름"),
                                                                                        actions: [
                                                                                            .cancelAction("취소", action: print("신고안함")),
                                                                                            .destructiveAction("확인", action: print("\"사용자 이름\"을(를) 신고하기"))
                                                                                        ])),
                                            .defaultAction("차단하기", action: router.alert(for: .blockUserConfirmationAlert(user: "사용자 이름"),
                                                                                        actions: [
                                                                                            .cancelAction("취소", action: print("차단안함")),
                                                                                            .destructiveAction("확인", action: print("\"사용자 이름\"을(를) 차단하기"))
                                                                                        ]))
                                          ])
            } label: {
                Text("Confirmation Dialog")
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
            // TODO: - 소셜 로그인 결과에 따라 회원가입 분기 필요
//            router.route(to: .requiredTermsView)
            
        } label: {
            Text("카카오로 로그인")
            // Image(.kakaoLogin)
            //     .resizable()
            //     .scaledToFit()
        }
        .onOpenURL { url in
            loginViewModel.onOpenURL(url: url)
        }
    }
}