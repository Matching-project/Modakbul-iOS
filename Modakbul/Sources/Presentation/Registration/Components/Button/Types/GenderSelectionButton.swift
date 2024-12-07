//
//  GenderSelectionButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct GenderSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItem: T?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if item.description == Gender.unknown.description {
                Text(item.description)
                    .frame(width: 250, height: 50)
                    .foregroundStyle(item == selectedItem ? .white : .accent)
                    .padding(10)
            } else {
                Image(item.description)
                    .resizable()
                    .padding(10)
                    .frame(maxHeight: 150)
                Text(item.description)
                    .foregroundStyle(item == selectedItem ? .white : .accent)
                    .padding(10)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.accent)
                .background(RoundedRectangle(cornerRadius: 20)
                    .shadow(color: .gray,
                            radius: 4,
                            x: 0.0,
                            y: 10.0)
                )
        }
        .foregroundStyle(item == selectedItem ? .accent : (colorScheme == .dark ? .black : .white))
    }
}
