//
//  MyCommunityRecruitingContentListView.swift
//  Modakbul
//
//  Created by Swain Yun on 8/27/24.
//

import SwiftUI

struct MyCommunityRecruitingContentListView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var viewModel: MyCommunityRecruitingContentListViewModel
    @AppStorage(AppStorageKey.userId) private var userId: Int = -1
    
    init(_ viewModel: MyCommunityRecruitingContentListViewModel) {
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
        .navigationTitle("나의 모집글")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.configureView(userId: Int64(userId))
        }
    }
}
