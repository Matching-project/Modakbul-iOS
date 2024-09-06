//
//  MyCommunityRecruitingContentListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class MyCommunityRecruitingContentListViewModel: ObservableObject {
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = []
    @Published var selectedTab: ActiveState = .continue
    let selection: [(ActiveState, String)] = [(.continue, "모집중"), (.completed, "모집완료")]
    
    private let communityRecruitingContentsSubject = PassthroughSubject<[CommunityRecruitingContent], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let matchingUseCase: MatchingUseCase
    
    init(matchingUseCase: MatchingUseCase) {
        self.matchingUseCase = matchingUseCase
        subscribe()
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
extension MyCommunityRecruitingContentListViewModel {
    func configureView(userId: Int64) async {
        do {
            let communityRecruitingContents = try await matchingUseCase.readMyRequestMatches(userId: userId)
            communityRecruitingContentsSubject.send(communityRecruitingContents)
        } catch {
            print(error)
        }
    }
}
