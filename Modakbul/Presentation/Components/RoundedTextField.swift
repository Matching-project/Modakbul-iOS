//
//  RoundedTextField.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/5/24.
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    let color: Color
    let disabled: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                // TODO: - When merging homeView to main branch...
                // 기존 RoundedRectangle(cornerRadius: RegistrationViewValue.RoundedTextField.cornerRadius)으로 바꿔놓을 것
                    .stroke(color)
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
    let lineLimit: (start: Int, end: Int)
    let disabled: Bool
    let color: Color
    
    init(_ titleKey: String = "",
         text: Binding<String>,
         axis: Axis = .horizontal,
         lineLimit: (start: Int, end: Int) = (1, 10),
         disabled: Bool = false,
         color: Color = .accent
    ) {
        self.titleKey = titleKey
        self.text = text
        self.axis = axis
        self.lineLimit = lineLimit
        self.disabled = disabled
        self.color = color
    }
    
    var body: some View {
        TextField(titleKey, text: text, axis: axis)
            .textFieldStyle(RoundedTextFieldStyle(color: color, disabled: disabled))
            .disabled(disabled)
            .lineLimit(lineLimit.start...lineLimit.end)
            .autocorrectionDisabled()
            .replaceDisabled()
    }
}
