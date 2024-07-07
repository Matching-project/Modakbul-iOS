//
//  ConfirmationDialogModifier.swift
//  Modakbul
//
//  Created by Swain Yun on 7/6/24.
//

import SwiftUI

extension View {
    func confirmationDialog(isPresented: Binding<Bool>, _ content: ConfirmationContent?) -> some View {
        self.modifier(ConfirmationDialogModifier(isPresented: isPresented, confirmationContent: content))
    }
}

struct ConfirmationDialogModifier: ViewModifier, ConfirmationContentPresentable {
    @Binding var isPresented: Bool
    
    private let confirmationContent: ConfirmationContent?
    
    init(isPresented: Binding<Bool>, confirmationContent: ConfirmationContent?) {
        self._isPresented = isPresented
        self.confirmationContent = confirmationContent
    }
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog(confirmationContent?.title ?? "",
                                isPresented: $isPresented,
                                titleVisibility: confirmationContent?.title == nil ? .hidden : .visible,
                                presenting: confirmationContent?.actions) { actions in
                confirmationButtons(actions)
            } message: { _ in
                Text(confirmationContent?.message ?? "")
            }
    }
}
