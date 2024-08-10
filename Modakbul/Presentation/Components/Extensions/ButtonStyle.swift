//
//  ButtonStyle.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI

struct CapsuledInsetButton: ButtonStyle {
    let foregroundColor: Color = .white
    let backgroundColor: Color = .accent
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
    }
}
