//
//  ImageView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/28/24.
//

import SwiftUI

struct ImageView<ClipShape: Shape>: View {
    private let image: Image
    private let shape: ClipShape
    private let contentMode: ContentMode
    private let width: CGFloat
    private let height: CGFloat
    
    init(_ imageResource: ImageResource,
         shape: ClipShape = .circle,
         contentMode: ContentMode = .fill,
         width: CGFloat = 200,
         height: CGFloat = 200
    ) {
        self.image = Image(imageResource)
        self.shape = shape
        self.contentMode = contentMode
        self.width = width
        self.height = height
    }
    
    init(_ image: Image,
         shape: ClipShape = .circle,
         contentMode: ContentMode = .fill,
         width: CGFloat = 200,
         height: CGFloat = 200
    ) {
        self.image = image
        self.shape = shape
        self.contentMode = contentMode
        self.width = width
        self.height = height
    }
    
    init(_ uiImage: UIImage,
         shape: ClipShape = .circle,
         contentMode: ContentMode = .fill,
         width: CGFloat = 200,
         height: CGFloat = 200
    ) {
        self.image = Image(uiImage: uiImage)
        self.shape = shape
        self.contentMode = contentMode
        self.width = width
        self.height = height
    }
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .clipShape(shape)
    }
}
