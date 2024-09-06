//
//  MyParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class MyParticipationRequestListViewModel: ObservableObject {
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = []
    
    private let communityRecruitingContentsSubject = PassthroughSubject<[CommunityRecruitingContent], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
    }
    
    private func subscribe() {
        communityRecruitingContentsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contents in
                self?.communityRecruitingContents = contents
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension MyParticipationRequestListViewModel {
    func configureView(userId: Int64) async {
        do {
            let communityRecruitingContents = try await matchingUseCase.readMyRequestMatches(userId: userId)
            communityRecruitingContentsSubject.send(communityRecruitingContents)
        } catch {
            print(error)
        }
    }
    
    func cancelParticipationRequest(userId: Int64, with communityRecruitingContentId: Int64) {
        Task {
            do {
                try await matchingUseCase.cancelMatchRequest(userId: userId, with: communityRecruitingContentId)
                if let index = communityRecruitingContents.firstIndex(where: {$0.id == communityRecruitingContentId}) {
                    communityRecruitingContents.remove(at: index)
                }
            } catch {
                print(error)
            }
        }
    }
}
