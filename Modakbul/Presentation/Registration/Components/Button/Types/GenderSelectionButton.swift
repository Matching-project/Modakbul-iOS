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
    
    var body: some View {
        VStack {
            Image(item.description)
                .foregroundStyle(.gray)
            Text(item.description)
                .foregroundStyle(item == selectedItem ? .white : .accent)
                .padding(RegistrationViewValue.GenderSelectionButton.padding)
        }
        .background {
            RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                .stroke(Color.accent)
                .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                    .shadow(color: .gray,
                            radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                            x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                            y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                )
        }
        .foregroundStyle(item == selectedItem ? .accent : .white)
    }
}
