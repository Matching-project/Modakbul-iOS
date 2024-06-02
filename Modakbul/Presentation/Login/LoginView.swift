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
}

#Preview {
    LoginView()
        .environmentObject(PreviewHelper.shared.router)
}
