//
//  AppleLoginButton.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            //
        }
        .frame(height: 50)
        .clipShape(Capsule())
    }
}

#Preview {
    AppleLoginButton()
}
