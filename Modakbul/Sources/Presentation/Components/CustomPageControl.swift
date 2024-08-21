//
//  CustomPageControl.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import SwiftUI

struct CustomPageControl: View {
    @Binding var currentPageIndex: Int
    let pageCountLimit: Int
    
    init(currentPageIndex: Binding<Int>, pageCountLimit: Int) {
        self._currentPageIndex = currentPageIndex
        self.pageCountLimit = pageCountLimit
    }
    
    var body: some View {
        HStack {
            ForEach(0..<pageCountLimit, id: \.self) { index in
                Circle()
                    .fill(currentPageIndex == index ? .accent : .white)
                    .frame(maxWidth: 10, maxHeight: 10)
            }
        }
        .padding(8)
        .background(.secondary)
        .clipShape(.capsule)
        .animation(.easeInOut, value: currentPageIndex)
    }
}
