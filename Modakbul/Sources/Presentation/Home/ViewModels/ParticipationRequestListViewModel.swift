//
//  ParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import Foundation
import Combine

final class ParticipationRequestListViewModel: ObservableObject {
    @Published var participationRequests: [ParticipationRequest] = []
    
    private let participationRequestsSubject = PassthroughSubject<[ParticipationRequest], Never>()
    private let indexPerformSubject = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
        subscribe()
    }
    
    private func subscribe() {
        participationRequestsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests in
                self?.participationRequests = requests
            }
            .store(in: &cancellables)
        
        indexPerformSubject
            .receive(on: DispatchQueue.main)
            .tryMap { [weak self] id in
                self?.participationRequests.firstIndex(where: { $0.id == id })
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure: return
                }
            } receiveValue: { [weak self] index in
                guard let index = index else { return }
                self?.participationRequests.remove(at: index)
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension ParticipationRequestListViewModel {
    func fetchParticipationRequests(userId: Int64, by communityRecruitingContentId: Int64) async {
        do {
            let requests = try await matchingUseCase.readMatches(userId: userId, with: communityRecruitingContentId)
            participationRequestsSubject.send(requests)
        } catch {
            participationRequests = []
        }
    }
    
    @MainActor
    func acceptParticipationRequest(_ userId: Int64, matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.acceptMatchRequest(userId: userId, with: matchingId)
                indexPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func rejectParticipationRequest(_ userId: Int64, matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.rejectMatchRequest(userId: userId, with: matchingId)
                indexPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
}
