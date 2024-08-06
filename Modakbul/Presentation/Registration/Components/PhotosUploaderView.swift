//
//  PhotosUploaderView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI
import PhotosUI

struct PhotosUploaderView: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @Binding var image: Data?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()) {
                // TODO: 이미지 추가해야함
                Circle()
                    .foregroundStyle(.gray)
                    .opacity(0.6)
                    .overlay {
                        if let userImage = image,
                           let uiImage = UIImage(data: userImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        // TODO: 이미지 추가해야함
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 50).weight(.light))
                    }
                    .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
            }
            .padding(RegistrationViewValue.PhotoUploader.padding)
    }
}
