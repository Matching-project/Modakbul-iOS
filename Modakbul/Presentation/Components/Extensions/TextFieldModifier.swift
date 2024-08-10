//
//  TextFieldModifier.swift
//  Modakbul
//
//  Created by Swain Yun on 7/25/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func automaticFunctionDisabled() -> some View {
        self.modifier(TextFieldModifier())
    }
}
