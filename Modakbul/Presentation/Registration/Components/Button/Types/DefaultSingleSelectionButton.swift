//
//  DefaultSingleSelectionButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct DefaultSingleSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItem: T?
    
    var body: some View {
        Text(item.description)
            .foregroundStyle(item == selectedItem ? .white : .accent)
            .frame(width: RegistrationViewValue.DefaultSelectionButton.widthFrame,
                   height: RegistrationViewValue.DefaultSelectionButton.heightFrame,
                   alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                    .stroke(Color.accent, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                        .shadow(color: .gray,
                                radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                                x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                                y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                    )
            }
            .foregroundStyle(item == selectedItem ? .accent : .white)
    }
}
