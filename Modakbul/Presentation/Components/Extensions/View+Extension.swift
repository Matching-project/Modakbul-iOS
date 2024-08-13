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
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 18)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
