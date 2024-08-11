//
//  DefaultMultipleSelectionButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct DefaultMultipleSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItems: Set<T>
    
    var body: some View {
        Text(item.description)
            .foregroundStyle(selectedItems.contains(item) ? .white : .accent)
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
            .foregroundStyle(selectedItems.contains(item) ? .accent : .white)
    }
}
