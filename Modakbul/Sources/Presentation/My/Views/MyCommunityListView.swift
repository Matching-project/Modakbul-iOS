//
//  MyCommunityListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import SwiftUI

struct MyCommunityListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MyCommunityListViewModel
    
    private let userId: Int64
    
    init(
        _ viewModel: MyCommunityListViewModel,
        userId: Int64
    ) {
        self.viewModel = viewModel
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            SelectionTab(
                selectedTab: $viewModel.selectedTab,
                viewModel.selection,
                viewModel.relationships) { relationship in
                    relationship.communityRecruitingContent.activeState == viewModel.selectedTab
                } onSelectCell: { relationship in
                    router.route(to: .placeInformationDetailView(placeId: relationship.placeId, locationName: relationship.locationName, communityRecruitingContentId: relationship.communityRecruitingContent.id, userId: userId))
                }
        }
        .padding()
        .navigationTitle("참여 모임 내역")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.configureView(userId: Int64(userId))
        }
    }
}
