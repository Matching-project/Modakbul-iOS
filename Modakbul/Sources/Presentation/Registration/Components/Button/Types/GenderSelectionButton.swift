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
            Image(item.description)
                .resizable()
                .padding(10)
                .frame(maxHeight: 150)
            Text(item.description)
                .foregroundStyle(item == selectedItem ? .white : .accent)
                .padding(RegistrationViewValue.GenderSelectionButton.padding)
        }
        .background {
            RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                .stroke(.accent)
                .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                    .shadow(color: .gray,
                            radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                            x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                            y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                )
        }
        .foregroundStyle(item == selectedItem ? .accent : (colorScheme == .dark ? .black : .white))
    }
}
