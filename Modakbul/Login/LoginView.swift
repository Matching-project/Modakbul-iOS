//
//  LoginView.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "questionmark")
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFit()
            
            Spacer()
            
            AppleLoginButton()
            
            Button {
                
            } label: {
                HStack {
                    Text("회원가입 없이")
                        .font(.headline)
                        .foregroundStyle(.black)
                    Text("둘러보기")
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
