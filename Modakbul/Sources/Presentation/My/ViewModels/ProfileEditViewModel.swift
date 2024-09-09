//
//  ProfileEditViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation

final class ProfileEditViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase

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
    @Published var isOverlappedNickname: Bool?

    // TODO: - 임시 mock 데이터 주입 수정 필요
    init(
        userRegistrationUseCase: UserRegistrationUseCase
    ) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    func isPassedNicknameRule() -> Bool {
        userRegistrationUseCase.validateInLocal(nickname)
    }
    
    @MainActor
    func checkNicknameForOverlap() {
        // TODO: - 로직 완성할 것
        Task {
            do {
                let status = try await userRegistrationUseCase.validateWithServer(nickname)
                switch status {
                case .normal:
                    // TODO: 정상
                    break
                case .overlapped:
                    // TODO: 중복된 닉네임
                    break
                case .abused:
                    // TODO: 부적절한 닉네임
                    break
                }
            } catch {
                
            }
        }
    }
    
    func submit() {
        // TODO: - 서버로 프로필

        // if nickname != user.nickname && nickname != "" {
        //     user.nickname = nickname
        // }
        
        // user.isGenderVisible = isGenderVisible
        // user.job = job!
        // user.categoriesOfInterest = categoriesOfInterest
    }
}
