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
            .defaultSelectionButtonModifier()
            .foregroundStyle(selectedItems.contains(item) ? .accent : .white)
    }
}
