//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            appLogo
            
            Spacer()
            
            AppleLoginButton()
            
            enteringButtonWithoutLogin
            
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
    
    private var enteringButtonWithoutLogin: some View {
        NavigationLink {
            HomeView()
        } label: {
            HStack {
                Text("회원가입 없이")
                    .font(.headline)
                    .foregroundStyle(.black)
                Text("둘러보기")
                    .foregroundStyle(.gray)
            }
        }

//        Button {
//            
//        } label: {
//            
//        }
    }
}

#Preview {
    LoginView()
        .environmentObject(PreviewHelper.shared.router)
}
