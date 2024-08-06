//
//  SingleSelectionButton.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct SingleSelectionButton<T: Selectable, Content: View>: View {
    @Binding var selectedItem: T?
    var columns: [GridItem] = Array(repeating: .init(.fixed(135)), count: 2)
    @ViewBuilder var content: (T, T?) -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button {
                    selectedItem = item
                } label: {
                    content(item, selectedItem)
                }
            }.padding(5)
        }
    }
}
