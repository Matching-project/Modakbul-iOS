//
//  DefaultCheckBox.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/1/24.
//

import SwiftUI

struct DefaultCheckBox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundStyle(.accent)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
