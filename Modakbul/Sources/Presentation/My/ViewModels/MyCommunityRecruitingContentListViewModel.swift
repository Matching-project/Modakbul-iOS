//
//  MyCommunityRecruitingContentListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class MyCommunityRecruitingContentListViewModel: ObservableObject {
    @Published var relationships: [CommunityRelationship] = []
    @Published var selectedTab: ActiveState = .continue
    let selection: [(ActiveState, String)] = [(.continue, "모집중"), (.completed, "모집완료")]
    
    private let relationshipsSubject = PassthroughSubject<[CommunityRelationship], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let communityUseCase: CommunityUseCase
    
    init(communityUseCase: CommunityUseCase) {
        self.communityUseCase = communityUseCase
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
extension MyCommunityRecruitingContentListViewModel {
    func configureView(userId: Int64) async {
        do {
            let relationships = try await communityUseCase.readMyCommunityRecruitingContents(userId: userId)
            relationshipsSubject.send(relationships)
        } catch {
            print(error)
        }
    }
}
