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
    private let matchingPerformSubject = PassthroughSubject<Int64, Never>()
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
        
        matchingPerformSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchingId in
                if let index = self?.matches.firstIndex(where: { $0.matchingId == matchingId }) { self?.matches.remove(at: index) }
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
    
    func cancelParticipationRequest(userId: Int64, with matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.cancelMatchRequest(userId: userId, with: matchingId)
                matchingPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
    
    func exitMatch(userId: Int64, with matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.exitMatch(userId: userId, with: matchingId)
                matchingPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
}
