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
    private var communityRecruitingContent: CommunityRecruitingContent?
    
    private let participationRequestsSubject = PassthroughSubject<[ParticipationRequest], Never>()
    private let indexPerformSubject = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    private let notificationUseCase: NotificationUseCase
    
    init(
        matchingUseCase: MatchingUseCase,
        notificationUseCase: NotificationUseCase
    ) {
        self.matchingUseCase = matchingUseCase
        self.notificationUseCase = notificationUseCase
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
    func fetchParticipationRequests(userId: Int64, by communityRecruitingContent: CommunityRecruitingContent) async {
        self.communityRecruitingContent = communityRecruitingContent
        
        do {
            let requests = try await matchingUseCase.readMatches(userId: userId, with: communityRecruitingContent.id)
            participationRequestsSubject.send(requests)
        } catch {
            participationRequestsSubject.send([])
        }
    }
    
    @MainActor
    func acceptParticipationRequest(_ userId: Int64, participationRequest request: ParticipationRequest) {
        guard let content = communityRecruitingContent else { return }
        let matchingId = request.id
        let opponentUserId = request.participatedUser.id
        
        Task {
            do {
                try await matchingUseCase.acceptMatchRequest(userId: userId, with: matchingId)
                indexPerformSubject.send(matchingId)
                try await notificationUseCase.send(content.id, from: userId, to: opponentUserId, subtitle: content.title, type: .acceptParticipation(communityRecruitingContentId: content.id))
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func rejectParticipationRequest(_ userId: Int64, participationRequest request: ParticipationRequest) {
        let matchingId = request.id
        
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
