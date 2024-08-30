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
            .defaultSelectionButtonModifier()
            .foregroundStyle(item == selectedItem ? .accent : .white)
    }
}
