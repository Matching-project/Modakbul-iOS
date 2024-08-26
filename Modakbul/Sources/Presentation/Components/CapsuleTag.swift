//
//  CapsuleTag.swift
//  Modakbul
//
//  Created by Swain Yun on 7/26/24.
//

import SwiftUI

// TODO: DynamicType 지원하도록 수정할 것
struct CapsuleTag: View {
    private let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .lineLimit(1)
            .padding(6)
            .background(.white)
            .clipShape(.capsule)
            .overlay(
                Capsule()
                    .strokeBorder(.accent)
            )
            .foregroundStyle(Color.accentColor)
    }
}

#Preview {
    CapsuleTag("모임 유형")
}