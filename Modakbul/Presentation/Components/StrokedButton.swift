//
//  StrokedButton.swift
//  Modakbul
//
//  Created by Swain Yun on 7/22/24.
//

import SwiftUI

struct StrokedButton<Content: View, Style: Shape>: View {
    private let shape: Style
    private let edge: Edge.Set
    private let length: CGFloat
    private let content: () -> Content
    private let action: () -> Void
    
    init(
        shape: Style,
        _ padding: Edge.Set = .all,
        _ length: CGFloat = 10,
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) {
        self.shape = shape
        self.edge = padding
        self.length = length
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            content()
                .font(.headline)
                .padding(edge, length)
                .background(.white)
                .overlay(
                    shape
                        .stroke(.accent, lineWidth: 4)
                )
                .clipShape(shape)
                .shadow(color: .secondary, radius: 4, y: 4)
        }
    }
}
