//
//  RegistrationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/29/24.
//

import SwiftUI

struct RegistrationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var registrationViewModel: RegistrationViewModel
    
    init(registrationViewModel: RegistrationViewModel) {
        self.registrationViewModel = registrationViewModel
    }
    var body: some View {
    
        view()
            .padding([.leading, .trailing], RegistrationViewValue.xAxisPadding)
            .onDisappear {
                registrationViewModel.submit()
                registrationViewModel.initialize()
            }
    }
}

extension RegistrationView {
    @ViewBuilder
    private func view() -> some View {
        switch registrationViewModel.currentField {
        case .name:
            contentStackView(isZStack: true) {
                RoundedTextField("30자 내로 입력해주세요", text: $registrationViewModel.name)
            }
        case .nickname:
            contentStackView(isZStack: true) {
                NicknameTextField(nickname: $registrationViewModel.nickname,
                                  isOverlapped: $registrationViewModel.isOverlappedNickname,
                                  disabledCondition: registrationViewModel.isPassedNicknameRule()
                ) {
                    registrationViewModel.checkNicknameForOverlap()
                }
            }
        case .birth:
            contentStackView(isZStack: true) {
                BirthPicker(birth: $registrationViewModel.birth)
            }
        case .gender:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Gender, GenderSelectionButton>(selectedItem: $registrationViewModel.gender) { (item, selectedItem) in
                    GenderSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .job:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Job, DefaultSingleSelectionButton>(selectedItem: $registrationViewModel.job) { (item, selectedItem) in
                    DefaultSingleSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .category:
            contentStackView(isZStack: false) {
                MultipleSelectionButton<Category, DefaultMultipleSelectionButton>(selectedItems: $registrationViewModel.categoriesOfInterest) { (item, selectedItem) in
                    DefaultMultipleSelectionButton(item: item, selectedItems: selectedItem)
                }
            }
        case .image:
            contentStackView(isZStack: false) {
                PhotosUploaderView(image: $registrationViewModel.image)
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
                    
                    FlatButton(registrationViewModel.currentField.buttonLabel(image: registrationViewModel.image)) {
                        if registrationViewModel.currentField != .image {
                            registrationViewModel.proceedToNextField()
                        } else {
                            router.popToRoot()
                        }
                    }
                    .disabled(!registrationViewModel.isNextButtonEnabled)
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
                
                FlatButton(registrationViewModel.currentField.buttonLabel(image: registrationViewModel.image)) {
                    if registrationViewModel.currentField != .image {
                        registrationViewModel.proceedToNextField()
                    } else {
                        router.popToRoot()
                    }
                }
                .disabled(!registrationViewModel.isNextButtonEnabled)
            }
        }
    }
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: RegistrationViewValue.Header.vStackSpacing
        ) {
            Text(registrationViewModel.currentField.title)
                .font(.title)
                .bold()
            Text(registrationViewModel.currentField.subtitle)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .padding(.top, RegistrationViewValue.Header.topPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
