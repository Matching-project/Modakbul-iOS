//
//  AsyncDynamicSizingImageView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct AsyncDynamicSizingImageView: View {
    private let url: URL?
    private let size: CGSize
    
    init(url: URL?, width: CGFloat, height: CGFloat) {
        self.url = url
        self.size = .init(width: width, height: height)
    }
    
    init(imageData: Data, width: CGFloat, height: CGFloat) {
        self.init(url: URL(dataRepresentation: imageData, relativeTo: nil), width: width, height: height)
    }
    
    init(urlString: String, width: CGFloat, height: CGFloat) {
        self.init(url: URL(string: urlString), width: width, height: height)
    }
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
        } placeholder: {
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
        }
    }
}
