//
//  CapsuledInsetButtonStyle.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI

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

struct CapsuledInsetButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                label
                    .font(.footnote.bold())
            }
            .buttonStyle(CapsuledInsetButtonStyle())
        }
    }
}
