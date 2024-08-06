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
    
    // MARK: - Private Methods
    private func dateComponentsToDate(_ dateComponents: DateComponents) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(from: dateComponents)!
    }
    
    // MARK: - Public Methods
    func proceedToNextField() {
        fieldIndex += 1
        fieldIndex %= allFields.count
        currentField = allFields[fieldIndex]
    }

    @MainActor
    func checkNicknameForOverlap() {
        // TODO: NetworkService를 통해 닉네임 쿼리 필요
        Task {
            isOverlappedNickname = try await userRegistrationUseCase.validate(nickname)
        }
    }
    
    func isPassedNicknameRule() -> Bool {
        let nicknamePattern = "^[가-힣a-zA-Z0-9]+$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknamePattern)
        
        guard nicknamePredicate.evaluate(with: nickname) else {
            return false
        }
        
        guard 2 <= nickname.count && nickname.count <= 15 else {
            return false
        }
        
        return true
    }
    
    func submit() {
        // TODO: Provider 수정할 것
        let user = User(email: email,
                        provider: .apple,
                        name: name,
                        nickname: nickname,
                        birth: dateComponentsToDate(birth),
                        gender: gender!,
                        job: job!,
                        categoriesOfInterest: categoriesOfInterest,
                        image: image,
                        isGenderVisible: false)
        
        Task {
            try await userRegistrationUseCase.register(user, encoded: image ?? Data())
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
