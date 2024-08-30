//
//  NicknameTextField.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

struct NicknameTextField: View {
    @Binding var nickname: String
    @Binding var isOverlapped: Bool?
    
    private let disabledCondition: Bool
    private let action: () -> Void
    
    init(
        nickname: Binding<String>,
        isOverlapped: Binding<Bool?>,
        disabledCondition: Bool,
        action: @escaping () -> Void
    ) {
        self._nickname = nickname
        self._isOverlapped = isOverlapped
        self.disabledCondition = disabledCondition
        self.action = action
    }
    
    var body: some View {
        HStack {
            RoundedTextField("한글, 영문, 숫자 2~15자", text: $nickname)
                .onChange(of: nickname) { _ in
                    isOverlapped = nil
                }
            
            RoundedButton {
                action()
            } label: {
                Text("중복확인")
                    .frame(minWidth: 60)
            }
            .disabled(!disabledCondition)
        }
    }
}

struct NicknameAlert: View {
    @Binding var isOverlapped: Bool?
    
    var body: some View {
        if let isOverlapped = isOverlapped {
            if isOverlapped {
                Text("중복된 닉네임입니다.\n최대 15자까지 입력 가능합니다.")
                    .foregroundStyle(.red)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
            } else {
                Text("사용 가능한 닉네임입니다.")
                    .foregroundStyle(.green)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}
