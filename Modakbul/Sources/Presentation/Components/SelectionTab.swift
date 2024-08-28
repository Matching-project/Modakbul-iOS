//
//  SelectionTab.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct SelectionTab<Selection: Selectable>: View {
    @Binding var selectedTab: Selection
    @Namespace private var namespace
    
    private let selection: [Selection]
    
    init(
        selectedTab: Binding<Selection>,
        _ selection: [Selection]
    ) {
        self._selectedTab = selectedTab
        self.selection = selection
    }
    
    var body: some View {
        HStack {
            ForEach(selection, id: \.id) { selection in
                tab(selection)
            }
        }
    }
    
    @ViewBuilder private func tab(_ selection: Selection) -> some View {
        Button {
            withAnimation {
                selectedTab = selection
            }
        } label: {
            VStack {
                Text(selection.description)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                
                if selectedTab == selection {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(height: 4)
                        .matchedGeometryEffect(id: "bar", in: namespace)
                }
            }
        }
    }
}
