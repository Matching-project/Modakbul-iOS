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
    @Published var user: User?
    
    // MARK: - Modified Data
    // 닉네임은 화면에 표시하지 않음.
    @Published var image: Data?
    @Published var nickname: String = ""
    @Published var gender: Gender = .unknown
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
        userBusinessUseCase.user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                // TODO: 기존 이미지 넣어주기
                self?.user = user
                self?.nickname = user.nickname
                self?.gender = user.gender
                self?.isGenderVisible = user.isGenderVisible
                self?.job = user.job
                self?.categoriesOfInterest = user.categoriesOfInterest
            }
            .store(in: &cancellables)
        
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
}

// MARK: Interfaces
extension ProfileEditViewModel {
    func configureView(_ userId: Int64) async {
        do {
            try await userBusinessUseCase.readMyProfile(userId: userId)
        } catch {
            print(error)
        }
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
        let user = User(
            id: user?.id ?? Constants.temporalId,
            nickname: nickname,
            job: job ?? .other,
            categoriesOfInterest: categoriesOfInterest,
            isGenderVisible: isGenderVisible
        )
        
        Task {
            do {
                try await userBusinessUseCase.updateProfile(user: user, image: image)
            } catch {
                print(error)
            }
        }
    }
    
    func initialize() {
        user = nil
        image = nil
        nickname.removeAll()
        isGenderVisible = true
        job = nil
        categoriesOfInterest = []
        integrityResult = nil
    }
}
