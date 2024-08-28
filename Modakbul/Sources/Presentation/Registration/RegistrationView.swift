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
    
    init(registrationViewModel: RegistrationViewModel) {
        self.vm = registrationViewModel
    }
    var body: some View {
        view()
            .padding(.horizontal, Constants.horizontal)
            .onDisappear {
                vm.submit()
                vm.initialize()
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
                                      isOverlapped: $vm.isOverlappedNickname,
                                      disabledCondition: vm.isPassedNicknameRule()
                    ) {
                        vm.checkNicknameForOverlap()
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    NicknameAlert(isOverlapped: $vm.isOverlappedNickname)
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
                
                FlatButton(vm.currentField.buttonLabel(image: vm.image)) {
                    if vm.currentField != .image {
                        vm.proceedToNextField()
                    } else {
                        router.popToRoot()
                    }
                }
                .disabled(!vm.isNextButtonEnabled)
            }
        }
    }
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: RegistrationViewValue.Header.vStackSpacing
        ) {
            Text(vm.currentField.title)
                .font(.title)
                .bold()
            Text(vm.currentField.subtitle)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .padding(.top, RegistrationViewValue.Header.topPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RegistrationView_Preview: PreviewProvider {
    static var previews: some View {
        router.view(to: .registrationView)
    }
}
