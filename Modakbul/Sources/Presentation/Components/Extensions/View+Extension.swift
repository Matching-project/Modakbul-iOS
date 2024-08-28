//
//  View+Extension.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/13/24.
//

import SwiftUI

extension View {
    func roundedRectangleStyle(cornerRadius: CGFloat = 8, lineWidth: CGFloat = 1, color: Color = .accentColor) -> some View {
        self
            .padding(.horizontal)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
    
    func defaultSelectionButtonModifier() -> some View {
        modifier(DefaultSelectionButtonModifier())
    }
    
    func navigationModifier(title: String, backButtonAction: @escaping () -> Void) -> some View {
        modifier(NavigationModifier(title: title, backButtonAction: backButtonAction))
    }
    
    func navigationPopGestureRecognizerEnabled() -> some View {
        background(GestureRecognizerEnabled())
    }
}
