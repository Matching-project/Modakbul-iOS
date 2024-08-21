//
//  MultipleSelectionButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct MultipleSelectionButton<T: Selectable, Content: View>: View {
    @Binding var selectedItems: Set<T>
    var columns: [GridItem] = Array(repeating: .init(.fixed(135)), count: 2)
    @ViewBuilder var content: (T, Set<T>) -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button {
                    if selectedItems.contains(item) && selectedItems.count > 1 {
                        selectedItems.remove(item)
                    } else {
                        selectedItems.insert(item)
                    }
                } label: {
                    content(item, selectedItems)
                }
            }
        }
    }
}
