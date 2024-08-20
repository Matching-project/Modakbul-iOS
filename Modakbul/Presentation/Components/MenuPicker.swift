//
//  MenuPicker.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/19/24.
//

import SwiftUI

struct MenuPicker {
    struct Default<T: Selectable>: View {
        @Binding var selection: T
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            Menu {
                Picker(selection: $selection) {
                    ForEach(Array(T.allCases), id: \.self) { item in
                        Text(item.description)
                    }
                } label: {}
            } label: {
                HStack {
                    Text(selection.description)
                        .tint(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                }
            }
        }
    }
    
    struct Range: View {
        @Binding var selection: Int
        @Environment(\.colorScheme) private var colorScheme
        var range: ClosedRange<Int>
        
        var body: some View {
            Menu {
                Picker(selection: $selection) {
                    ForEach(range, id: \.self) { value in
                        Text("\(value)")
                    }
                } label: {}
            } label: {
                HStack {
                    Text(selection.description)
                        .tint(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                }
            }
        }
    }
}
