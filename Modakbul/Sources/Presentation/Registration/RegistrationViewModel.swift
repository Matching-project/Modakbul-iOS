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
    private let fcmManager = FcmManager.instance
    private let allFields: [RegisterField] = RegisterField.allCases
    private var fieldIndex: Int = 0

    // MARK: Data From User
    @Published var id: Int64?
    @Published var name = ""
    @Published var nickname = "닉네임 테스트"
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
//            return integrityResult == .normal
            // MARK: - 테스트 위해 임시로 다음 버튼 강제 허용
            return true
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
        
        fcmManager.$fcmToken
            .sink { [weak self] fcmToken in
                self?.fcm = fcmToken
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
        guard let fcm = fcm else { return }
        
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
                    let userId = try await userRegistrationUseCase.kakaoRegister(user,
                                                                                 encoded: image,
                                                                                 email: userCredential.email!,
                                                                                 fcm: fcm,
                                                                                 provider: userCredential.provider)
                    userIdSubject.send(userId)
                } catch {
                    print(error)
                }
            }
        case .apple:
            Task {
                do {
                    let userId = try await userRegistrationUseCase.appleRegister(user,
                                                                                 encoded: image,
                                                                                 authorizationCode: userCredential.authorizationCode!,
                                                                                 fcm: fcm,
                                                                                 provider: userCredential.provider)
                    
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
        integrityResult = nil
    }
}
