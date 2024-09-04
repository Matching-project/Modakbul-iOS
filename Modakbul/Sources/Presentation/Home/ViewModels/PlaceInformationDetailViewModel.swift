//
//  PlaceInformationDetailViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation
import Combine

final class PlaceInformationDetailViewModel: ObservableObject {
    @Published var communityRecruitingContent: CommunityRecruitingContent?
    
    private let communityRecruitingContentSubject = PassthroughSubject<CommunityRecruitingContent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let chatUseCase: ChatUseCase
    private let communityUseCase: CommunityUseCase
    
    init(
        chatUseCase: ChatUseCase,
        communityUseCase: CommunityUseCase
    ) {
        self.chatUseCase = chatUseCase
        self.communityUseCase = communityUseCase
        subscribe()
    }
    
    private func subscribe() {
        communityRecruitingContentSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                self?.communityRecruitingContent = content
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension PlaceInformationDetailViewModel {
    func configureView(_ communityRecruitingContentId: Int64) async throws {
        let communityRecruitingContent = try await communityUseCase.readCommunityRecruitingContentDetail(with: communityRecruitingContentId)
        communityRecruitingContentSubject.send(communityRecruitingContent)
    }
}
