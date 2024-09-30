//
//  MyParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class MyParticipationRequestListViewModel: ObservableObject {
    @Published var requests: [MatchRequest] = []
    
    private let requestsSubject = PassthroughSubject<[MatchRequest], Never>()
    private let requestPerformSubject = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
        subscribe()
    }
    
    private func subscribe() {
        requestsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests in
                self?.requests = requests
            }
            .store(in: &cancellables)
        
        requestPerformSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchingId in
                if let index = self?.requests.firstIndex(where: { $0.matchingId == matchingId }) { self?.requests.remove(at: index) }
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension MyParticipationRequestListViewModel {
    func configureView(userId: Int64) async {
        do {
            let requests = try await matchingUseCase.readMyRequestMatches(userId: userId)
            requestsSubject.send(requests)
        } catch {
            requestsSubject.send([])
            print(error)
        }
    }
    
    func cancelParticipationRequest(userId: Int64, with matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.cancelMatchRequest(userId: userId, with: matchingId)
                requestPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
    
    func exitMatch(userId: Int64, with matchingId: Int64) {
        Task {
            do {
                try await matchingUseCase.exitMatch(userId: userId, with: matchingId)
                requestPerformSubject.send(matchingId)
            } catch {
                print(error)
            }
        }
    }
}
