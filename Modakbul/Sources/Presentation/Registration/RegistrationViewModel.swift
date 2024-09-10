//
//  RegistrationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/6/24.
//

import SwiftUI
import Combine

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
    @Published var integrityResult: NicknameIntegrityType?
    
    private let integrityResultSubject = PassthroughSubject<NicknameIntegrityType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var isNextButtonEnabled: Bool {
        switch currentField {
        case .name:
            return !name.isEmpty && name.count <= 30
        case .nickname:
            return integrityResult == .normal
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
        subscribe()
    }
    
    private func subscribe() {
        integrityResultSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.integrityResult = result
            }
            .store(in: &cancellables)
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
        Task {
            let status = try await userRegistrationUseCase.validateWithServer(nickname)
            integrityResultSubject.send(status)
        }
    }
    
    @MainActor
    func submit(_ provider: AuthenticationProvider, fcm: String) -> Int64 {
        // TODO: Provider 수정할 것
        let user = User(name: name,
                        nickname: nickname,
                        gender: gender ?? .unknown,
                        job: job ?? .other,
                        categoriesOfInterest: categoriesOfInterest,
                        isGenderVisible: false,
                        birth: birth.toDate())
        
        Task {
            do {
                return try await userRegistrationUseCase.register(user, encoded: image, provider: provider, fcm: <#FCM TOKEN#>)
            } catch {
                print(error)
            }
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
        integrityResult = nil
    }
}
