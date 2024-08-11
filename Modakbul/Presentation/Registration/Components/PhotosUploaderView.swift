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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()) {
                Image(colorScheme == .dark ? .photoUploadMainLight : .photoUploadMainDark)
                    .resizable()
                    .frame(maxWidth: 200, maxHeight: 200)
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
                        Image(.photoUploadSub)
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                    }
                    .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
            }
            .padding(RegistrationViewValue.PhotoUploader.padding)
    }
}
