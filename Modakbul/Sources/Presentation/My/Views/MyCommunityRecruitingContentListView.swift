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
    
    init(_ viewModel: MyCommunityRecruitingContentListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SelectionTab(selectedTab: $viewModel.selectedTab, viewModel.selection)
            
            List(viewModel.communityRecruitingContents, id: \.id) { content in
                if content.activeState == viewModel.selectedTab {
                    listCell(content)
                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
    
    @ViewBuilder private func listCell(_ content: CommunityRecruitingContent) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(content.title)
                .font(.headline)
            
            HStack(spacing: 10) {
                Text(content.community.category.description)
                
                Text("\(content.community.participantsCount)/\(content.community.participantsLimit)명")
                
                Text(content.community.meetingDate)
                
                Text("\(content.community.startTime)~\(content.community.endTime)")
            }
            .font(.caption)
        }
        .listRowSeparator(.hidden)
        .padding(.vertical, 4)
        .contentShape(.rect)
        .onTapGesture {
            router.route(to: .placeInformationDetailView(communityRecruitingContentId: content.id))
        }
    }
}
