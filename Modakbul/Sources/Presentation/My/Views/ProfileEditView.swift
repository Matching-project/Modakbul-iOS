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

final class ProfileEditViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase

    // MARK: - Original Data
    @Published var user: User
    
    // MARK: - Modified Data
    // 닉네임은 화면에 표시하지 않음.
    @Published var image: Data?
    @Published var nickname: String
    @Published var isGenderVisible: Bool
    // 회원가입시 Job?으로 받는 코드 구조여서 불가피하게 Job이 아닌 Job?으로 선언
    @Published var job: Job?
    @Published var categoriesOfInterest: Set<Category>
    
    // MARK: - For Binding
    @Published var isOverlappedNickname: Bool? = nil

    // TODO: - 임시 mock 데이터 주입 수정 필요
    init(userRegistrationUseCase: UserRegistrationUseCase,
         user: User = PreviewHelper.shared.users.first ?? User()
    ) {
        self.userRegistrationUseCase = userRegistrationUseCase
        self.user = user
        self.nickname = ""
        self.isGenderVisible = user.isGenderVisible
        self.job = user.job
        self.categoriesOfInterest = user.categoriesOfInterest
    }
    
    func isPassedNicknameRule() -> Bool {
        userRegistrationUseCase.validateInLocal(nickname)
    }
    
    @MainActor
    func checkNicknameForOverlap() {
        // TODO: - NetworkService를 통해 닉네임 쿼리 필요
        Task {
            isOverlappedNickname = try await userRegistrationUseCase.validateWithServer(nickname)
          }
    }
    
    func submit() {
        // TODO: - 서버로 프로필

        // if nickname != user.nickname && nickname != "" {
        //     user.nickname = nickname
        // }
        
        // user.isGenderVisible = isGenderVisible
        // user.job = job!
        // user.categoriesOfInterest = categoriesOfInterest
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
