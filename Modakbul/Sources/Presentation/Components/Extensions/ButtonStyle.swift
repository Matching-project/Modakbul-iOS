//
//  ButtonStyle.swift
//  Modakbul
//
//  Created by Swain Yun on 8/27/24.
//

import SwiftUI

extension ButtonStyle where Self == CapsuledInsetButtonStyle {
    static var capsuledInset: CapsuledInsetButtonStyle {
        CapsuledInsetButtonStyle()
    }
}

struct CapsuledInsetButtonStyle: ButtonStyle {
    let foregroundColor: Color = .white
    let backgroundColor: Color = .accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
    }
}
