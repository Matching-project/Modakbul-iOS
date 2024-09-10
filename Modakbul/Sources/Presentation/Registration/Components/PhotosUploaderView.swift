//
//  PhotosUploaderView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI
import PhotosUI

struct PhotosUploaderView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @Binding var image: Data?
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - 이미지를 수정하기 전 기존 이미지를 불러옵니다.
    private let url: URL?
    
    init(image: Binding<Data?>, url: URL? = nil) {
        self._image = image
        self.url = url
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()) {
                
                // 1-1. 기존이미지에서 이미지 선택: url o, image o
                // 1-2. 기존이미지: url o , image x
                // 2-1. 기본이미지에서 이미지 선택: url x, image o
                // 2-2. 기본이미지: url x, image x
                
                if let url = url {
                    if let image = image, let uiImage = UIImage(data: image) {
                        ImageView(uiImage)
                            .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
                    } else {
                        AsyncImageView(url: url, contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(.circle)
                            .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
                    }
                } else {
                    if let image = image, let uiImage = UIImage(data: image) {
                        ImageView(uiImage)
                            .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
                    } else {
                        ImageView(colorScheme == .dark ? .modakbulMainLight: .modakbulMainDark)
                            .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
                    }
                }
            }
    }
}
