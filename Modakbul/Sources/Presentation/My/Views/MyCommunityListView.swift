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
    @AppStorage(AppStorageKey.userId) private var userId: Int = -1
    
    init(_ viewModel: MyCommunityListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SelectionTab(
                selectedTab: $viewModel.selectedTab,
                viewModel.selection,
                viewModel.communityRecruitingContents) { content in
                    content.activeState == viewModel.selectedTab
                } onSelectCell: { content in
                    router.route(to: .placeInformationDetailView(communityRecruitingContentId: content.id, userId: Int64(userId)))
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
