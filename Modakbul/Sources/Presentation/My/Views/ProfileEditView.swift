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
    @AppStorage(AppStorageKey.userNickname) private var userNickname: String = String()
    
    private let user: User
    
    init(
        profileEditViewModel: ProfileEditViewModel,
        user: User
    ) {
        self.vm = profileEditViewModel
        self.user = user
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 40) {
                    PhotosUploaderView(image: $vm.image, url: vm.user.imageURL)
                    nickname
                    gender
                    job
                    categoriesOfInterest
                }
                .padding(.horizontal, Constants.horizontal)
                .padding(.vertical, Constants.vertical)
            }
            .task {
                await vm.configureView(user.id)
            }
            .onDisappear {
                vm.initialize()
            }
            
            FlatButton("저장") {
                vm.submit()
                userNickname = vm.nickname
                router.dismiss()
            }
            .padding(.horizontal, Constants.horizontal)
        }
    }
    
    private var nickname: some View {
        LazyVStack(spacing: 10) {
            Text("닉네임 변경")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.Modakbul.title)
                .bold()
            
            NicknameTextField(nickname: $vm.nickname,
                              integrityResult: $vm.integrityResult,
                              disabledCondition: vm.isPassedNicknameRule()) {
                vm.checkNicknameForOverlap()
            }
            
            NicknameAlert(integrityResult: $vm.integrityResult)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // TODO: - 닉네임 변경시 textField, Button과 상이한 액션...
    private var gender: some View {
        LazyVStack(spacing: 10) {
            Text("성별 표시")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.Modakbul.title)
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
                .font(.Modakbul.title)
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
                .font(.Modakbul.title)
                .bold()
            
            MultipleSelectionButton<Category, DefaultMultipleSelectionButton>(selectedItems: $vm.categoriesOfInterest) { (item, selectedItem) in
                DefaultMultipleSelectionButton(item: item, selectedItems: selectedItem)
            }
        }
    }
}

struct ProfileEditView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .profileEditView(user: User()))
    }
}
