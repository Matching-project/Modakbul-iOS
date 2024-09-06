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
                viewModel.communityRecruitingContents) { content in
                    content.activeState == viewModel.selectedTab
                } onSelectCell: { content in
                    router.route(to: .placeInformationDetailView(communityRecruitingContentId: content.id))
                }
        }
        .padding()
        .navigationTitle("참여 모임 내역")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.configureView(userId: userId)
        }
    }
}
