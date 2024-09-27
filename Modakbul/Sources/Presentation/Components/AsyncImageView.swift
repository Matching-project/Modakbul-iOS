//
//  AsyncDynamicSizingImageView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct AsyncImageView<ClipShape: Shape>: View {   
    private let url: URL?
    private let contentMode: ContentMode
    private let maxWidth: CGFloat
    private let maxHeight: CGFloat
    private let clipShape: ClipShape
    
    init(url: URL?,
         contentMode: ContentMode = .fit,
         maxWidth: CGFloat = 64,
         maxHeight: CGFloat = 64,
         clipShape: ClipShape = .rect
    ) {
        self.url = url
        self.contentMode = contentMode
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.clipShape = clipShape
    }
    
    init(imageData: Data,
         contentMode: ContentMode = .fit,
         maxWidth: CGFloat = 64,
         maxHeight: CGFloat = 64,
         clipShape: ClipShape = .rect
    ) {
        self.init(url: URL(dataRepresentation: imageData, relativeTo: nil),
                  contentMode: contentMode,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  clipShape: clipShape)
    }
    
    init(urlString: String,
         contentMode: ContentMode = .fit,
         maxWidth: CGFloat = 64,
         maxHeight: CGFloat = 64,
         clipShape: ClipShape = .rect
    ) {
        self.init(url: URL(string: urlString),
                  contentMode: contentMode,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  clipShape: clipShape)
    }
    
    var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
            case .failure:
                Image(.modakbulMain)
                    .resizable()
            @unknown default:
                Image(.modakbulMain)
                    .resizable()
            }
        }
        .aspectRatio(contentMode: contentMode)
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .frame(minWidth: 64, minHeight: 64)
        .clipShape(clipShape)
        .clipped()
    }
}
