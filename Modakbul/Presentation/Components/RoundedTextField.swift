//
//  RoundedTextField.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/5/24.
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                // TODO: - When merging homeView to main branch...
                // 기존 RoundedRectangle(cornerRadius: RegistrationViewValue.RoundedTextField.cornerRadius)으로 바꿔놓을 것
                    .stroke(Color.accent)
            }
    }
}

struct RoundedTextField: View {
    let titleKey: String
    let text: Binding<String>
    
    init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        self.text = text
    }
    
    var body: some View {
        TextField(titleKey, text: text)
            .textFieldStyle(RoundedTextFieldStyle())
    }
}
