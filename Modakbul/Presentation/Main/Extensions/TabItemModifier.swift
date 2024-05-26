//
//  TabItemModifier.swift
//  Modakbul
//
//  Created by Swain Yun on 5/26/24.
//

import SwiftUI

struct TabItemModifier: ViewModifier {
    let pageType: PageType
    let tint: Color
    
    init(
        type pageType: PageType,
        color tint: Color
    ) {
        self.pageType = pageType
        self.tint = tint
    }
    
    func body(content: Content) -> some View {
        content
            .tabItem { pageType.label }
            .tag(pageType)
    }
}

extension View {
    func tabItemStyle(_ pageType: PageType, color: Color = .primary) -> some View {
        self.modifier(TabItemModifier(type: pageType, color: color))
    }
}
