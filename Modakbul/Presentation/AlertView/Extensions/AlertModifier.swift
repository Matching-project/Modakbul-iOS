//
//  AlertModifier.swift
//  Modakbul
//
//  Created by Swain Yun on 7/5/24.
//

import SwiftUI

extension View {
    func alert(_ alertContent: AlertContent?, isPresented: Binding<Bool>) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, content: alertContent))
    }
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    private let alertContent: AlertContent?
    
    init(isPresented: Binding<Bool>, content: AlertContent?) {
        self.alertContent = content
        self._isPresented = isPresented
    }
    
    func body(content: Content) -> some View {
        content
            .alert(alertContent?.title ?? "", isPresented: $isPresented, presenting: alertContent?.actions) { actions in
                alertButtons(actions)
            } message: { _ in
                Text(alertContent?.message ?? "")
            }

    }
    
    @ViewBuilder private func alertButtons(_ actions: [AlertAction?]) -> some View {
        let actions = actions.compactMap({$0})
        
        ForEach(actions, id: \.id) { action in
            switch action {
            case .defaultAction(let title, let action):
                Button {
                    action()
                } label: {
                    Text(title)
                }
            case .cancelAction(let title, let action):
                Button(role: .cancel) {
                    action()
                } label: {
                    Text(title)
                }
            case .destructiveAction(let title, let action):
                Button(role: .destructive) {
                    action()
                } label: {
                    Text(title)
                }
            }
        }
    }
}
