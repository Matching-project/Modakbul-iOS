//
//  StrokedButton.swift
//  Modakbul
//
//  Created by Swain Yun on 7/23/24.
//

import SwiftUI

struct StrokedButton<Content: View, ClipShape: Shape>: View {
    private let clipShape: ClipShape
    private let edge: Edge.Set
    private let length: CGFloat
    private let content: () -> Content
    private let action: () -> Void
    
    init(
        _ shape: ClipShape,
        _ padding: Edge.Set = .all,
        _ length: CGFloat = 10,
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) {
        self.clipShape = shape
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
                    clipShape
                        .stroke(.accent, lineWidth: 4)
                )
                .clipShape(clipShape)
                .shadow(color: .secondary.opacity(0.5), radius: 4, y: 4)
        }
    }
}

struct StrokedFilledButton<Content: View, ClipShape: Shape>: View {
    private let clipShape: ClipShape
    private let edge: Edge.Set
    private let length: CGFloat
    private let content: () -> Content
    private let action: () -> Void
    
    init(
        _ shape: ClipShape,
        _ padding: Edge.Set = .all,
        _ length: CGFloat = 10,
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) {
        self.clipShape = shape
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
                .foregroundStyle(.white)
                .background(.accent)
                .overlay(
                    clipShape
                        .stroke(.white, lineWidth: 4)
                )
                .clipShape(clipShape)
                .shadow(color: .secondary.opacity(0.5), radius: 4, y: 4)
        }
    }
}
