//
//  View+Extension.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import SwiftUI

extension View {
    func roundedRectangleStyle(cornerRadius: CGFloat = 8,
                               lineWidth: CGFloat = 1,
                               color: Color = .accentColor,
                               vertical: CGFloat = 18) -> some View {
        self
            .padding(.horizontal)
            .padding(.vertical, vertical)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
    
    func defaultSelectionButtonModifier() -> some View {
        modifier(DefaultSelectionButtonModifier())
    }
    
    func navigationModifier<MenuContent: View>(title: String? = nil,
                                               backButtonAction: @escaping () -> Void,
                                               @ViewBuilder menuButtonAction: @escaping () -> MenuContent = {  EmptyView() } ) -> some View {
        modifier(NavigationModifier(title: title, backButtonAction: backButtonAction, menuButtonAction: menuButtonAction))
    }
    
    func navigationPopGestureRecognizerEnabled() -> some View {
        background(GestureRecognizerEnabled())
    }
}
