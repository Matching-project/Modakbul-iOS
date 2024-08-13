//
//  RoundedTextField.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/5/24.
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    let disabled: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                // TODO: - When merging homeView to main branch...
                // 기존 RoundedRectangle(cornerRadius: RegistrationViewValue.RoundedTextField.cornerRadius)으로 바꿔놓을 것
                    .stroke(Color.accent)
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(disabled ? .gray : .clear)
                    .opacity(disabled ? 0.4 : 1.0)
            }
    }
}

struct RoundedTextField: View {
    let titleKey: String
    let text: Binding<String>
    let axis: Axis
    let disabled: Bool
    
    init(_ titleKey: String,
         text: Binding<String>,
         axis: Axis = .horizontal,
         disabled: Bool = false
    ) {
        self.titleKey = titleKey
        self.text = text
        self.axis = axis
        self.disabled = disabled
    }
    
    var body: some View {
        TextField(titleKey, text: text, axis: axis)
            .textFieldStyle(RoundedTextFieldStyle(disabled: disabled))
            .disabled(disabled)
    }
}
