//
//  MyParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation

final class MyParticipationRequestListViewModel: ObservableObject {
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = []
}

// MARK: Interfaces
extension MyParticipationRequestListViewModel {
    func cancelParticipationRequest() {
        
    }
}
