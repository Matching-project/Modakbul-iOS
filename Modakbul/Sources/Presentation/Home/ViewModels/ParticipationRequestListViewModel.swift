//
//  ParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import Foundation

final class ParticipationRequestListViewModel: ObservableObject {
    @Published var participationRequests: [ParticipationRequest] = []
    
//    private let communityUseCase: CommunityUseCase
    
//    init(communityUseCase: CommunityUseCase) {
//        self.communityUseCase = communityUseCase
//    }
}

// MARK: Interfaces
extension ParticipationRequestListViewModel {
    func fetchParticipationRequests(by communityRecruitingContentId: Int64) async {
//        participationRequests = await communityUseCase.fetchParticipantsList(communityRecruitingContentId)
    }
}
