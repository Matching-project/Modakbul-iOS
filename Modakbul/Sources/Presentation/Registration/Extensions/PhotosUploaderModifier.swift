//
//  PhotosUploaderModifier.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/29/24.
//

import SwiftUI
import PhotosUI

extension View {
    func getPhoto(selectedPhoto: Binding<PhotosPickerItem?>, image: Binding<Data?>) -> some View {
        modifier(PhotosUploaderModifier(selectedPhoto: selectedPhoto, image: image))
    }
}

struct PhotosUploaderModifier: ViewModifier {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var image: Data?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: selectedPhoto) { _, newItem in
                guard let newItem = newItem else { return }
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        Task { @MainActor in
                            image = data
                        }
                    case .failure:
                        print("프로필 사진 불러오기 실패")
                        break
                    }
                }
            }
    }
}
