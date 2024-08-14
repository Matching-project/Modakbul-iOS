//
//  AsyncDynamicSizingImageView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import SwiftUI

struct AsyncImageView: View {
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    init(imageData: Data) {
        self.init(url: URL(dataRepresentation: imageData, relativeTo: nil))
    }
    
    init(urlString: String) {
        self.init(url: URL(string: urlString))
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(let error):
                // TODO: 기본 이미지 필요
                Image(systemName: "heart.fill")
            @unknown default:
                Image(systemName: "heart.fill")
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(minWidth: 64, minHeight: 64)
    }
}
