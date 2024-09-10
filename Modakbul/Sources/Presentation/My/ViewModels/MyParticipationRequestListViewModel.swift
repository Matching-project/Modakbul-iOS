//
//  MyParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

typealias Matches = [(communityRecruitingContent: CommunityRecruitingContent, matchingId: Int64, matchState: MatchState)]

final class MyParticipationRequestListViewModel: ObservableObject {
    @Published var matches: Matches = []
    
    private let matchesSubject = PassthroughSubject<Matches, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
    }
    
    private func subscribe() {
        matchesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matches in
                self?.matches = matches
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension MyParticipationRequestListViewModel {
    func configureView(userId: Int64) async {
        do {
            let matches = try await matchingUseCase.readMyRequestMatches(userId: userId)
            matchesSubject.send(matches)
        } catch {
            print(error)
        }
    }
    
    func cancelParticipationRequest(userId: Int64, with communityRecruitingContentId: Int64) {
        Task {
            do {
                try await matchingUseCase.cancelMatchRequest(userId: userId, with: communityRecruitingContentId)
                if let index = matches.firstIndex(where: {$0.communityRecruitingContent.id == communityRecruitingContentId}) {
                    matches.remove(at: index)
                }
            } catch {
                print(error)
            }
        }
    }
}
