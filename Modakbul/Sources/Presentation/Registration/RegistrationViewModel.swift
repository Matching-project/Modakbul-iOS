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
    @Published var id: Int64?
    @Published var name = ""
    @Published var nickname = ""
    // MARK: - 애플 심사 정책상, 불필요한 개인정보 수집 방지를 위해 뷰에서는 불필요한 생년월일을 수집하는 화면을 제거함.
    // MARK: - 다만, backend 로직상 생년월일을 받도록 되어 있어 편의상 수정사항이 일어나지 않도록 뷰를 제외한 기존 코드는 유지함.
    @Published var birth: DateComponents = DateComponents(year: 2000, month: 1, day: 1)
    @Published var gender: Gender? = nil
    @Published var job: Job? = nil
    @Published var categoriesOfInterest: Set<Category> = []
    @Published var image: Data? = nil
    
    // MARK: For Binding
    @Published var currentField: RegisterField = .name
    @Published var integrityResult: NicknameIntegrityType?
    @Published var isWaiting: Bool = false
    
    private var fcm: String?
    
    private let userIdSubject = PassthroughSubject<Int64, Never>()
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
        userIdSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                self?.id = id
                self?.isWaiting = false
            }
            .store(in: &cancellables)
        
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
    func submit(_ userCredential: UserCredential) {
        let user = User(name: name,
                        nickname: nickname,
                        gender: gender ?? .unknown,
                        job: job ?? .other,
                        categoriesOfInterest: categoriesOfInterest,
                        isGenderVisible: false,
                        birth: birth.toDate())
        
        isWaiting.toggle()
        
        switch userCredential.provider {
        case .kakao:
            Task {
                do {
                    let userId = try await userRegistrationUseCase.register(user, encoded: image, userCredential)
                    userIdSubject.send(userId)
                } catch {
                    print(error)
                }
            }
        case .apple:
            Task {
                do {
                    let userId = try await userRegistrationUseCase.register(user, encoded: image, userCredential)
                    userIdSubject.send(userId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func initialize() {
        name = ""
        nickname = ""
        birth = DateComponents(year: 2000, month: 1, day: 1)
        gender = nil
        job = nil
        categoriesOfInterest = []
        image = nil
        currentField = .name
        fieldIndex = 0
        integrityResult = nil
        isWaiting = false
    }
}
