//
//  MyCommunityRecruitingContentListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation

final class MyCommunityRecruitingContentListViewModel: ObservableObject {
    @Published var communityRecruitingContents: [CommunityRecruitingContent] = PreviewHelper.shared.communityRecruitingContents
    @Published var selectedTab: ActiveState = .continue
    let selection: [ActiveState] = [.continue, .completed]
}
