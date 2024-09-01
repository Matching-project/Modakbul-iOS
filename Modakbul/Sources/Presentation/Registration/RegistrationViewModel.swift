//
//  RegistrationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI

final class RegistrationViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let allFields: [RegisterField] = RegisterField.allCases
    private var fieldIndex: Int = 0

    // MARK: Data From User
    @Published var email = ""
    @Published var name = ""
    @Published var nickname = ""
    @Published var birth: DateComponents = DateComponents(year: 2000, month: 1, day: 1)
    @Published var gender: Gender? = nil
    @Published var job: Job? = nil
    @Published var categoriesOfInterest: Set<Category> = []
    @Published var image: Data? = nil
    
    // MARK: For Binding
    @Published var currentField: RegisterField = .name
    @Published var isOverlappedNickname: Bool? = nil
    
    var isNextButtonEnabled: Bool {
        switch currentField {
        case .name:
            return !name.isEmpty && name.count <= 30
        case .nickname:
            return !(isOverlappedNickname ?? true)
        case .gender:
            return gender != nil
        case .job:
            return job != nil
        case .category:
            return !categoriesOfInterest.isEmpty
        default: return true
        }
    }
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    // MARK: - Public Methods
    func proceedToNextField() {
        fieldIndex += 1
        fieldIndex %= allFields.count
        currentField = allFields[fieldIndex]
    }

    func isPassedNicknameRule() -> Bool {
        userRegistrationUseCase.validateInLocal(nickname)
    }
    
    @MainActor
    func checkNicknameForOverlap() {
        // TODO: NetworkService를 통해 닉네임 쿼리 필요
        Task {
            isOverlappedNickname = try await userRegistrationUseCase.validateWithServer(nickname)
          }
    }
    
    func submit() {
        // TODO: Provider 수정할 것
        let user = User(id: -1,
                        name: name,
                        nickname: nickname,
                        gender: gender ?? .unknown,
                        job: job ?? .other,
                        categoriesOfInterest: categoriesOfInterest,
                        isGenderVisible: false,
                        birth: birth.toDate())
        
        Task {
            try await userRegistrationUseCase.register(user, encoded: image)
            // TODO: - 회원가입 완료되면 회원정보 조회 API를 통해 user.imageURL 채워넣기.
            // TODO: - 그래야 마이페이지로 이동할 때 API 요청 필요 없음
        }
    }
    
    func initialize() {
        email = ""
        name = ""
        nickname = ""
        birth = DateComponents(year: 2000, month: 1, day: 1)
        gender = nil
        job = nil
        categoriesOfInterest = []
        image = nil
        currentField = .name
        isOverlappedNickname = nil
    }
}
