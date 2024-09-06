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
    
    private let userId: Int64
    
    init(
        _ viewModel: MyCommunityRecruitingContentListViewModel,
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
        .navigationTitle("나의 모집글")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.configureView(userId: userId)
        }
    }
}
