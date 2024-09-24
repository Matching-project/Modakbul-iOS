//
//  AsyncDynamicSizingImageView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct AsyncImageView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let url: URL?
    private let contentMode: ContentMode
    private let minWidth: CGFloat
    private let minHeight: CGFloat
    
    init(url: URL?,
         contentMode: ContentMode = .fit,
         minWidth: CGFloat = 64,
         minHeight: CGFloat = 64
    ) {
        self.url = url
        self.contentMode = contentMode
        self.minWidth = minWidth
        self.minHeight = minHeight
    }
    
    init(imageData: Data,
         contentMode: ContentMode = .fit,
         minWidth: CGFloat = 64,
         minHeight: CGFloat = 64
    ) {
        self.init(url: URL(dataRepresentation: imageData, relativeTo: nil),
                  contentMode: contentMode,
                  minWidth: minWidth,
                  minHeight: minHeight
        )
    }
    
    init(urlString: String,
         contentMode: ContentMode = .fit,
         minWidth: CGFloat = 64,
         minHeight: CGFloat = 64
    ) {
        self.init(url: URL(string: urlString),
                  contentMode: contentMode,
                  minWidth: minWidth,
                  minHeight: minHeight
        )
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
                Image(colorScheme == .dark ? .modakbulMainDark : .modakbulMainLight)
                    .resizable()
            @unknown default:
                Image(colorScheme == .dark ? .modakbulMainDark : .modakbulMainLight)
                    .resizable()
            }
        }
        .aspectRatio(contentMode: contentMode)
        .frame(minWidth: minWidth, minHeight: minHeight)
    }
}
