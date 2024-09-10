//
//  ProfileEditViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation
import Combine

final class ProfileEditViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let userBusinessUseCase: UserBusinessUseCase

    // MARK: - Original Data
    @Published var user: User = User()
    
    // MARK: - Modified Data
    // 닉네임은 화면에 표시하지 않음.
    @Published var image: Data?
    @Published var nickname: String = ""
    @Published var isGenderVisible: Bool = true
    // 회원가입시 Job?으로 받는 코드 구조여서 불가피하게 Job이 아닌 Job?으로 선언
    @Published var job: Job?
    @Published var categoriesOfInterest: Set<Category> = []
    
    // MARK: - For Binding
    @Published var integrityResult: NicknameIntegrityType?
    
    private let nicknameIntegritySubject = PassthroughSubject<NicknameIntegrityType, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(
        userRegistrationUseCase: UserRegistrationUseCase,
        userBusinessUseCase: UserBusinessUseCase
    ) {
        self.userRegistrationUseCase = userRegistrationUseCase
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        nicknameIntegritySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.integrityResult = result
            }
            .store(in: &cancellables)
        
        $nickname
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.integrityResult = nil
            }
            .store(in: &cancellables)
    }
    
    func isPassedNicknameRule() -> Bool {
        userRegistrationUseCase.validateInLocal(nickname)
    }
    
    @MainActor
    func checkNicknameForOverlap() {
        Task {
            do {
                let status = try await userRegistrationUseCase.validateWithServer(nickname)
                nicknameIntegritySubject.send(status)
            } catch {
                print(error)
            }
        }
    }
    
    func submit() {
        Task {
            do {
                try await userBusinessUseCase.updateProfile(user: user, image: image)
            } catch {
                print(error)
            }
        }
    }
}
