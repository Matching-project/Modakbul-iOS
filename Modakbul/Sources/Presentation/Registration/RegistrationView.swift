//
//  RegistrationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/29/24.
//

import SwiftUI

struct RegistrationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var vm: RegistrationViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = Constants.loggedOutUserId
    
    private let userCredential: UserCredential
    
    init(_ vm: RegistrationViewModel, userCredential: UserCredential) {
        self.vm = vm
        self.userCredential = userCredential
    }
    
    var body: some View {
        view()
            .padding(.horizontal, Constants.horizontal)
            .onDisappear {
                vm.initialize()
            }
            .onReceive(vm.$id) { id in
                guard let id = id else { return }
                userId = Int(id)
                router.popToRoot()
            }
    }
}

extension RegistrationView {
    @ViewBuilder
    private func view() -> some View {
        switch vm.currentField {
        case .name:
            contentStackView(isZStack: true) {
                RoundedTextField("30자 내로 입력해주세요", text: $vm.name)
            }
        case .nickname:
            contentStackView(isZStack: true) {
                GeometryReader { geometry in
                    NicknameTextField(nickname: $vm.nickname,
                                      integrityResult: $vm.integrityResult,
                                      disabledCondition: vm.isPassedNicknameRule()
                    ) {
                        vm.checkNicknameForOverlap()
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    NicknameAlert(integrityResult: $vm.integrityResult)
                        .position(x: geometry.size.width / 2 - 70, y: geometry.size.height / 2 + 60)
                }
            }
        case .birth:
            contentStackView(isZStack: true) {
                BirthPicker(birth: $vm.birth)
            }
        case .gender:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Gender, GenderSelectionButton>(selectedItem: $vm.gender) { (item, selectedItem) in
                    GenderSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .job:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Job, DefaultSingleSelectionButton>(selectedItem: $vm.job) { (item, selectedItem) in
                    DefaultSingleSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .category:
            contentStackView(isZStack: false) {
                MultipleSelectionButton<Category, DefaultMultipleSelectionButton>(selectedItems: $vm.categoriesOfInterest) { (item, selectedItem) in
                    DefaultMultipleSelectionButton(item: item, selectedItems: selectedItem)
                }
            }
        case .image:
            contentStackView(isZStack: false) {
                PhotosUploaderView(image: $vm.image)
            }
        }
    }
    
    @ViewBuilder
    private func contentStackView<Content: View>(isZStack: Bool, content: @escaping () -> Content) -> some View {
        if isZStack {
            ZStack {
                VStack {
                    header
                    
                    Spacer()
                    
                    FlatButton(vm.currentField.buttonLabel(image: vm.image)) {
                        if vm.currentField != .image {
                            vm.proceedToNextField()
                        } else {
                            router.popToRoot()
                        }
                    }
                    .disabled(!vm.isNextButtonEnabled)
                }
                content()
            }
        } else {
            VStack {
                header
                
                Spacer()
                
                content()
                
                Spacer()
                Spacer()
                
                FlatButton(vm.isWaiting ? "처리 중" : vm.currentField.buttonLabel(image: vm.image)) {
                    if vm.currentField != .image {
                        vm.proceedToNextField()
                    } else {
                        vm.submit(userCredential)
                    }
                }
                .disabled(!vm.isNextButtonEnabled || vm.isWaiting)
            }
        }
    }
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(vm.currentField.title)
                .font(.Modakbul.title)
                .bold()
            Text(vm.currentField.subtitle)
                .font(.Modakbul.headline)
                .foregroundStyle(.gray)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
