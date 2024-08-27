//
//  ParticipationRequestListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/9/24.
//

import Foundation

final class ParticipationRequestListViewModel: ObservableObject {
    @Published var participationRequests: [ParticipationRequest] = PreviewHelper.shared.communityRecruitingContents.map {
        .init(id: $0.id, participatedUser: $0.writer)
    }
}
