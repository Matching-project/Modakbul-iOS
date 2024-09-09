//
//  ProfileEditView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/26/24.
//

import SwiftUI

struct ProfileEditView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: ProfileEditViewModel

    init(profileEditViewModel: ProfileEditViewModel) {
        self.vm = profileEditViewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                PhotosUploaderView(image: $vm.image, url: vm.user.imageURL)
                nickname
                gender
                job
                categoriesOfInterest
            }
            .padding(.horizontal, Constants.horizontal)
        }
        
        FlatButton("저장") {
            vm.submit()
            router.dismiss()
        }
        .padding(.horizontal, Constants.horizontal)
    }
    
    private var nickname: some View {
        LazyVStack(spacing: 10) {
            Text("닉네임 변경")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
            
            NicknameTextField(nickname: $vm.nickname,
                              isOverlapped: $vm.isOverlappedNickname,
                              disabledCondition: vm.isPassedNicknameRule()) {
                vm.checkNicknameForOverlap()
            }
            
            NicknameAlert(isOverlapped: $vm.isOverlappedNickname)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // TODO: - 닉네임 변경시 textField, Button과 상이한 액션...
    private var gender: some View {
        LazyVStack(spacing: 10) {
            Text("성별 표시")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
            
            HStack {
                Text(vm.user.gender.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .roundedRectangleStyle()
                
                RoundedButton {
                    vm.isGenderVisible.toggle()
                } label: {
                    Text(vm.isGenderVisible.toggleDescription)
                        .frame(minWidth: 60)
                }
            }
        }
    }
    
    private var job: some View {
        LazyVStack(spacing: 20) {
            Text("직업 변경")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
            
            SingleSelectionButton<Job, DefaultSingleSelectionButton>(selectedItem: $vm.job) { (item, selectedItem) in
                DefaultSingleSelectionButton(item: item, selectedItem: selectedItem)
            }
        }
    }
    
    private var categoriesOfInterest: some View {
        LazyVStack(spacing: 20) {
            Text("카테고리 변경")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
            
            MultipleSelectionButton<Category, DefaultMultipleSelectionButton>(selectedItems: $vm.categoriesOfInterest) { (item, selectedItem) in
                DefaultMultipleSelectionButton(item: item, selectedItems: selectedItem)
            }
        }
    }
}

struct ProfileEditView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            router.view(to: .profileEditView)
                .navigationModifier(title: "") { 
                    router.dismiss()
                }
        }
    }
}
