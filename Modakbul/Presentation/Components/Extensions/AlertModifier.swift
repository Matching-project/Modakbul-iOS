//
//  AlertModifier.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import SwiftUI

extension View {
    func alert(isPresented: Binding<Bool>, _ content: ConfirmationContent?) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, content: content))
    }
}

struct AlertModifier: ViewModifier, ConfirmationContentPresentable {
    @Binding var isPresented: Bool
    
    private let confirmationContent: ConfirmationContent?
    
    init(isPresented: Binding<Bool>, content: ConfirmationContent?) {
        self._isPresented = isPresented
        self.confirmationContent = content
    }
    
    func body(content: Content) -> some View {
        content
            .alert(confirmationContent?.title ?? "", isPresented: $isPresented, presenting: confirmationContent?.actions) { actions in
                confirmationButtons(actions)
            } message: { _ in
                if let message = confirmationContent?.message {
                    Text(message)
                }
            }
    }
}
