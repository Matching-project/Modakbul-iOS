//
//  MyCommunityListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation

final class MyCommunityListViewModel: ObservableObject {
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = PreviewHelper.shared.communityRecruitingContents
    @Published var selectedTab: ActiveState = .continue
    let selection: [(ActiveState, String)] = [(.continue, "예정된 모임"), (.completed, "지난 모임")]
}
