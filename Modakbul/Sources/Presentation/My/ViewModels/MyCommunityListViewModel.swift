//
//  MyCommunityListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class MyCommunityListViewModel: ObservableObject {
    @Published var relationships: [CommunityRelationship] = []
    @Published var selectedTab: ActiveState = .continue
    let selection: [(ActiveState, String)] = [(.continue, "예정된 모임"), (.completed, "지난 모임")]
    
    private let relationshipsSubject = PassthroughSubject<[CommunityRelationship], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
        subscribe()
    }
    
    private func subscribe() {
        relationshipsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] relationships in
                self?.relationships = relationships
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension MyCommunityListViewModel {
    func configureView(userId: Int64) async {
        do {
            let relationships = try await matchingUseCase.readMyMatches(userId: userId)
            relationshipsSubject.send(relationships)
        } catch {
            print(error)
        }
    }
}
